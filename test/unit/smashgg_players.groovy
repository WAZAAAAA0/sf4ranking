import groovy.json.JsonSlurper
import groovy.transform.ToString

def tournament = "evo-2019"
def filename = tournament.replace("-", "_")+".csv"
def url = "https://api.smash.gg/tournament/$tournament/attendees"
//https://smash.gg/api/-/gg_api./tournament/evo-2017/attendees;filter={"gamerTag":"daigo"};

@ToString
class Attendee {
    String name
    String gamertag
    Integer id
    Integer attendeeId
    Integer participantId
    String country
    String state
    String twitter
    String tag
    List<Event> events = []
}

@ToString
class Event {
    Integer id
    String name
    List<Pool> pools = []
    Integer entrantId
    Integer seed
}

@ToString
class Pool {
    Integer id
    String name
    String group
    Integer phaseSeed
    Integer nextPhase
    Integer phaseId
}

def phaseCache = [:]

def getPhaseData = { Integer id ->
    if (phaseCache[id]) {
        return phaseCache[id]
    }
    else {
        JsonSlurper slurper = new JsonSlurper()
        def phaseurl = "https://api.smash.gg/phase_group/$id?expand[]=seeds&expand[]=groups".toURL()
        def phasedata = slurper.parse(phaseurl)
        phaseCache[id] = phasedata
        return phasedata
    }
}

List<Attendee> attendees = []
boolean hasNext = true
def page = 1
def perpage = 100
Map<String, List<Attendee>> groupByEvent = [:]
Map<String, List<Attendee>> groupByUniqueEvent = [:]

while (hasNext) {
    def apiQuery = url+"?page=$page&per_page=$perpage"
    println "parsing page $apiQuery"
    def smashdata = apiQuery.toURL().text
    def data = new JsonSlurper().parseText(smashdata)
    def attendeeNodes = data.items.entities.attendee
    def attendeesBatch = attendeeNodes.collect { node ->
        def attendee = new Attendee(name: node.player?.name, id: node.player?.id, gamertag: node.player?.gamerTag, country: node.player?.country, state: node.player?.state)
        attendee.attendeeId = node.id
        attendee.twitter = node.player?.twitterHandle
        attendee.tag = node.player?.prefix
        attendee.events = node.events.collect {
            def evt = new Event(name: it.name, id: it.id)
            def entrant = node.entrants.find { it.eventId == evt.id }
            evt.entrantId = entrant?.id
            return evt
        }
        node.pools.each { poolnode ->
            def event = attendee.events.find { it.id == poolnode.eventId }
            if (poolnode.phaseOrder == 1 || poolnode.phaseName == "Phase 1" || poolnode.phaseName == "Pools") {
                def poolobj = new Pool(id: poolnode.phaseGroupId, name: poolnode.phaseName, group: poolnode.groupName, phaseId: poolnode.phaseId)
                event.pools << poolobj
                def phasedata = getPhaseData(poolnode.phaseGroupId)
                def entrantdata = phasedata.entities.seeds.find { it.entrantId == event.entrantId }
                def groupdata = phasedata.entities.groups
                event.seed = entrantdata?.seedNum
                poolobj.phaseSeed = entrantdata?.groupSeedNum
                poolobj.nextPhase = groupdata.winnersTargetPhaseId
            }
        }
        println attendee
        return attendee
    }
    attendees.addAll(attendeesBatch)
    if (attendeesBatch) { page++ }
    else { hasNext = false }
}

println "[SUMMARY]"
println "Players: ${attendees.size()}"
println "Registrations: ${attendees.sum { it.events.size() }}"
def countByCountry = attendees.countBy { it.country }
def groupByCountry =  attendees.groupBy { it.country }

println "Countries: ${groupByCountry.size()}"

def sortByCountry = countByCountry.sort { a, b -> b.value <=> a.value }
println sortByCountry

println "[COUNTRIES]"
sortByCountry.each {
    println "$it.key, $it.value"
}

println "[PLAYERS PER COUNTRY]"
groupByCountry.sort {a,b -> b.value.size() <=> a.value.size() }.each {
    println "$it.key: ${it.value.collect { it.gamertag?: it.name }.join(", ")}"
}

attendees.each { attendee ->
    attendee.events.each { event ->
        if (!(event.name =~ /Ladder/)) {
            if (!groupByEvent.containsKey(event.name)) groupByEvent[event.name] = []
            groupByEvent[event.name] << attendee
            if (attendee.events.size() == 1) {
                if (!groupByUniqueEvent.containsKey(event.name)) groupByUniqueEvent[event.name] = []
                groupByUniqueEvent[event.name] << attendee
            }
        }
    }
}

println "[GAMES]"
groupByEvent.each {
    def countGameByCountry =  it.value.countBy { it.country }
    def uniques = groupByUniqueEvent[it.key]?: []
    println "$it.key, ${it.value.size()}, ${countGameByCountry.size()}, ${uniques.size()}"
}

def events = groupByEvent.keySet()
println "x , players, "+events.join(",")
groupByEvent.each { eventGroup ->
    def playerIds = eventGroup.value.collect { it.id }
    def overlap = events.collect { event ->
        def otherPlayersIds = groupByEvent[event].id
        def overlappingIds = playerIds.findAll { it in otherPlayersIds }
        return overlappingIds.size()
    }
    println "$eventGroup.key,${playerIds.size()},"+overlap.join(",")
}

println "[OVERLAP %]"
println "x , players, "+events.join(",")
groupByEvent.each { eventGroup ->
    def playerIds = eventGroup.value.collect { it.id }
    def overlap = events.collect { event ->
        def otherPlayersIds = groupByEvent[event].id
        def overlappingIds = playerIds.findAll { it in otherPlayersIds }
        return ((overlappingIds.size() / playerIds.size()))
    }
    println "$eventGroup.key,${playerIds.size()},"+overlap.join(",")
}

def groupByEventSize = attendees.groupBy { it.events.size() }
groupByEventSize.sort { a, b -> a.key <=> b.key }.each {
    println "$it.key, ${it.value.size()}"
}
groupByEventSize.each {
    println "$it.key: ${it.value.gamertag.join(',')}"
}

println "[DETAIL DATA]"

def file = new File("/Users/bbr/Desktop/newsmash/$filename")
file.delete()
file.withPrintWriter { writer ->
    attendees.each { p ->
        p.events.each {
            def tokens = [p.id?: "", p.attendeeId?: "", p.tag?:"", p.gamertag?:"", p.name?:"", p.country?:"", p.state?:"", p.twitter?:"", it.name?:"", it.pools[0]?.id?:"", it.pools[0]?.name?:"", it.pools[0]?.group?:"", it.entrantId, it.seed, it.pools[0]?.phaseSeed, it.pools[0]?.nextPhase, it.pools[0]?.phaseId]
            def clean = tokens.collect { it.toString().replace(",","-") }.collect { it.toString().replace("\"","'") }
            def quoted = clean.collect { "\"$it\"" }
            def line = quoted.join(",")
            writer.println(line)
        }
    }
}

