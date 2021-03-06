package be.bbr.sf4ranking

import grails.transaction.Transactional
import org.hibernate.criterion.CriteriaSpecification

/**
 * Specific queries to the database
 */
@Transactional
class QueryService
{

    /**
     * Search for players using parameters and paging
     */
    List<Player> findPlayers(CharacterType ctype, CountryCode countryCode, Integer max, Integer offset, Version game, RankingType rankingType = RankingType.ACTUAL)
    {
        log.info "Looking for $max players of ctype ${ctype} from country ${countryCode} starting from $offset in game $game with type $rankingType"
        def rankField = rankingType.field
        def playerIdQuery = Player.createCriteria()
        def playerids = playerIdQuery.list(max: max, offset: offset) {
            createAlias("rankings", "rankAlias", CriteriaSpecification.LEFT_JOIN)
            projections {
                distinct 'id'
            }
            eq("rankAlias.game", game)
            property("rankAlias.${rankField}")
            gt("rankAlias.${rankField}", 0)
            if (rankingType == RankingType.WEIGHT) {
                order("rankAlias.${rankField}", "desc")
            }
            else {
                order("rankAlias.${rankField}", "asc")
            }

            if (countryCode) eq("countryCode", countryCode)
            if (ctype)
            {
                and {
                    results {
                        characterTeams {
                            pchars {
                                eq("characterType", ctype)
                            }
                        }
                    }
                }
            }
        }
        def players = Player.getAll(playerids)
        players.retainAll { it.findRanking(game) != null }
        return players

    }

    List<Player> findCptPlayers(Region region = Region.GLOBAL)
    {
        log.info "Looking for all CPT players"
        def playerIdQuery = Player.createCriteria()
        def playerids = playerIdQuery.list(max: 400) {
            createAlias("rankings", "rankAlias", CriteriaSpecification.LEFT_JOIN)
            createAlias("cptRankings", "cptAlias", CriteriaSpecification.LEFT_JOIN)
            projections {
                distinct 'id'
            }
            eq("rankAlias.game", Version.SF5)
            eq("cptAlias.region", region)
            property("cptAlias.score")
            gt("cptAlias.score", 0)
            order("cptAlias.score", "desc")
        }
        def players = Player.getAll(playerids)
        log.info "Returned all CPT players ${players.size()}"
        return players
    }

    Integer countPlayers(CharacterType ctype, CountryCode countryCode, Version game)
    {
        def playerCountQuery = Player.createCriteria()
        def playercount = playerCountQuery.get() {
            createAlias("rankings", "rankAlias", CriteriaSpecification.LEFT_JOIN)
            projections {
                countDistinct 'id'
            }
            eq("rankAlias.game", game)
            gt("rankAlias.rank", 0)
            if (countryCode) eq("countryCode", countryCode)
            if (ctype)
            {
                results {
                    characterTeams {
                        pchars {
                            eq("characterType", ctype)
                        }
                    }
                }
            }
        }
        return playercount
    }

    Integer countPlayerResults(Player player, Version game)
    {
        def resultCountQuery = Result.createCriteria()
        def rcount = resultCountQuery.get() {
            projections {
                countDistinct 'id'
            }
            tournament {
                eq("game", game)
            }
            eq("player", player)
        }
        return rcount
    }

    Integer countPlayerResultsAfter(Player player, Version game, Date start, Date end)
    {
        def resultCountQuery = Result.createCriteria()
        def rcount = resultCountQuery.get() {
            projections {
                countDistinct 'id'
            }
            tournament {
                eq("game", game)
                ge("date", start)
                if (end) {
                    le("date", end)
                }
            }
            eq("player", player)
        }
        return rcount
    }

    List<String> getActiveCountryNames()
    {
        def countries = Player.createCriteria().list {
            projections {
                distinct "countryCode"
            }
        }
        return countries.findResults() {it?.name}
    }

    List<Player> findOrphanedPlayers()
    {
        def playerQuery = Player.createCriteria()
        return playerQuery.list() {
            isEmpty("rankings")
        }
    }

    Tournament lastTournament(Version game) {
        def query = Tournament.createCriteria()
        def last = query.list(max: 1) {
            eq("game", game)
            eq("finished", true)
            order("date", "desc")
        }
        return last.size() > 0? last.first() : null
    }

    List<Tournament> lastTournaments(Version game, Integer number) {
        def query = Tournament.createCriteria()
        def last = query.list(max: number) {
            if (game) {
                eq("game", game)
            }
            eq("finished", true)
            order("date", "desc")
        }
        return last
    }


    List<Tournament> upcomingCptTournaments() {
        return Tournament.where {
            game == Version.SF5 &&
                    cptTournament != null &&
                    cptTournament != CptTournament.NONE &&
                    finished == false
        }.list()
    }

    List<Tournament> pastCptTournaments() {
        return Tournament.where {
            game == Version.SF5 &&
                    cptTournament != null &&
                    cptTournament != CptTournament.NONE &&
                    finished == true
        }.list()
    }

}
