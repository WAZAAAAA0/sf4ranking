class UrlMappings {

	static mappings = {
        name playerByName: "/$controller/player/byname/$name"{
            action = "playerByName"
        }
        name tournamentByName: "/$controller/tournament/byname/$name"{
            action = "tournamentByName"
        }
        name teamByName: "/$controller/team/byname/$name"{
            action = "teamByName"
        }
        name eventByName: "/$controller/event/byname/$name"{
            action = "eventByName"
        }
        name apiPlayerById: "/$controller/player/id/$name"{
            action = "playerById"
        }
        name apiPlayerByName: "/$controller/player/name/$name"{
            action = "playerByName"
        }
        name apiPlayerBySmashId: "/$controller/player/smash/$smashId"{
            action = "playerBySmashId"
        }
        name apiTournamentById: "/$controller/tournament/id/$name"{
            action = "tournamentById"
        }
        name apiTournamentByName: "/$controller/tournament/name/$name"{
            action = "tournamentByName"
        }
        name apiTournamentByGame: "/$controller/tournament/game/$game"{
            action = "tournamentByGame"
        }
        "/$controller/$action?/$id?(.${format})?"{
            constraints {
            }
        }
        "500"(controller: "errors", action: "concurrent",
              exception: IllegalAccessException)
        "500"(view: "/error")
        "/"(controller: "rankings")
	}
}
