package be.bbr.sf4ranking

import groovy.transform.ToString

@ToString(includePackage = false, ignoreNulls = true)
class Result
{

    static constraints = {
        player nullable: false
        place nullable: false
        tournament nullable: false
    }

    static mapping = {
        player index: 'p_Idx'
        tournament index: 't_Idx'
    }

    static belongsTo = [tournament:Tournament, player: Player]
    static hasMany = [characterTeams: GameTeam]

    Player player
    Tournament tournament
    Integer place
}
