<%@ page import="be.bbr.sf4ranking.TournamentFormat; be.bbr.sf4ranking.TournamentType; be.bbr.sf4ranking.ScoringSystem" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="overviews"/>
    <title>Fighting Games World Ranking - REST API</title>
</head>

<body>
<h2>REST/JSON API</h2>
<div class="jumbotron">
    <p>
    <h2>Important</h2>
You can use the SRK FGC ranking API to query the database for player rankings and tournament results. This allows you to a lot of fancy stuff that we look forward to!
   <br/>
    If you want to do datamining, it is advised to use the raw JSON data used as backup of this site. This can be found in the open-source code of this project at
    <a href="https://github.com/bavobbr/sf4ranking">https://github.com/bavobbr/sf4ranking</a> in the <a href="https://github.com/bavobbr/sf4ranking/tree/master/grails-app/conf/data">data folder.
    </a>. This avoids you to query all one by one.
    You are free to use this data in any fashion that contributes back to the community. The data can not be commercialized or be used in closed databases.
</p>

</div>
<h2>How does it work?</h2>
There are two types of entities:
<ol>
    <li>Player: get player meta-information and all his results</li>
    <li>Tournament: get tournament meta-information and all the results</li>
</ol>

<h3>Search</h3>

One can search either for player or for tournament. This is speicfied with the 'type' query parameter.
Other parameters:
<ul>
    <li>query: search term, of 'string' type</li>
    <li>fuzzy: do fuzzy search, of 'boolean' type</li>
</ul>

Examples:
<ul>
    <li><g:link controller="api" action="search" params="[type: 'player', fuzzy: 'false', query: 'daigo']">/api/search?type=player&query=daigo&fuzzy=false</g:link></li>
    <li><g:link controller="api" action="search" params="[type: 'player', fuzzy: 'true', query: 'daigo']">/api/search?type=player&query=daigo&fuzzy=true</g:link></li>
    <li><g:link controller="api" action="search" params="[type: 'tournament', fuzzy: 'true', query: 'evolution']">/api/search?type=tournament&query=evolution</g:link></li>
</ul>


<h3>Data fetch</h3>

You can fetch data either by id or by name. By ID is advised for scripts that cross-reference data between search/player/tournament. By name is simply human-friendly.
<ul>
    <li><g:link controller="api" action="playerById" params="[name: '200']" mapping="apiPlayerById">/api/player/id/200</g:link></li>
    <li><g:link controller="api" action="playerByName" params="[name: 'Sako']" mapping="apiPlayerByName">/api/player/name/sako</g:link></li>
    <li><g:link controller="api" action="tournamentById" params="[name: '10']" mapping="apiTournamentById">/api/tournament/id/10</g:link></li>
    <li><g:link controller="api" action="tournamentByName" params="[name: 'EVOLUTION 2014 - USF4']" mapping="apiTournamentByName">/api/tournament/name/EVOLUTION 2014 - USF4</g:link></li>

</ul>

Do not use the API as a remote database for clients such as mobile apps or websites. If you create clients that directly use this API, make sure it is efficient.
</body>
</html>