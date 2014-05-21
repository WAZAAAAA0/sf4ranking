<%@ page import="org.apache.shiro.SecurityUtils; be.bbr.sf4ranking.Version; be.bbr.sf4ranking.TournamentFormat; be.bbr.sf4ranking.TournamentType; be.bbr.sf4ranking.ScoringSystem" contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="overviews"/>
  <r:require modules="bootstrap"/>
  <title>Character statistics for game ${game?.value}</title>
</head>

<body>

<h2>Character statistics for ${game}</h2>

<h3>Character usage details</h3>

<div class="alert alert-info alert-dismissable">
  <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
  You can sort on the columns by clicking the header! WORK IN PROGRESS
</div>
<ul class="nav nav-pills">
  <g:each in="${Version.values()}" var="g">
    <li class="${game == g ? 'active' : 'passive'}"><g:link controller="stats" action="index" params="[game: g.name()]">${g.
            name()}</g:link></li>
  </g:each>
</ul>
&nbsp;

<div class="table-responsive">
  <table class="tablehead" id="datatable">
    <thead>
    <tr class="stathead">
      <th>Character</th>
      <th>Times listed <a href="#" data-toggle="tooltip" data-placement="top"
                          title="Number of times this character appeared in the tournament results">(?)</a></th>
      <th>List % <a href="#" data-toggle="tooltip" data-placement="top"
                    title="Percentage of times this character appeared in the tournament results">(?)</a></th>
      <th>Base Score <a href="#" data-toggle="tooltip" data-placement="top"
                        title="Sum of scores earned by players who used this character in tournaments">(?)</a></th>
      <th>Score <a href="#" data-toggle="tooltip" data-placement="top"
                   title="Sum of decayed scores earned by players who used this character in tournaments">(?)</a></th>
      <th>Rank <a href="#" data-toggle="tooltip" data-placement="top"
                  title="Sum of ranks earned by players who used this character in tournaments">(?)</a></th>
      <th>Main top 50 <a href="#" data-toggle="tooltip" data-placement="top"
                         title="Number of top 50 players who use this character as main">(?)</a></th>
      <th>Main top 100 <a href="#" data-toggle="tooltip" data-placement="top"
                          title="Number of top 100 players who use this character as main">(?)</a></th>
      <th>Main total <a href="#" data-toggle="tooltip" data-placement="top" title="Number of players who use this character as main">(?)</a>
      </th>
      <th>Best player <a href="#" data-toggle="tooltip" data-placement="top"
                         title="Highest ranked player who uses this char as main">(?)</a></th>
      <th>Best rank <a href="#" data-toggle="tooltip" data-placement="top" title="Highest rank of this character as main">(?)</a></th>
    </tr>
    </thead>
    <g:each in="${results}" var="cstat">
      <tr>
        <td>
      <g:link action="character" controller="stats" params="[charname: cstat.characterType.name(), game: game.name()]"
              data-toggle="tooltip" data-placement="top"
              title="Filter on ${cstat.characterType.value}">
        <g:img dir="images/chars/${Version.generalize(game).name().toLowerCase()}"
               file="${cstat.characterType.name().toLowerCase() + '.png'}" width="22" height="25"
               alt="${cstat.characterType.value}"
               class="charimg"/>
        ${cstat.characterType.value}
      </g:link>
      </td>
      <td>${cstat.totalTimesUsed}</td>
      <td>
        ${cstat.totalUsagePercentage?.round(1)}
      </td>
      <td>${cstat.scoreAccumulated}</td>
      <td>${cstat.decayedScoreAccumulated}</td>
      <td>${cstat.rankAccumulated}</td>
      <td>${cstat.asMainInTop50}</td>
      <td>${cstat.asMainInTop100}</td>
      <td>${cstat.asMain}</td>
      <td>
        <g:if test="${cstat.player}">
          <g:link controller="rankings" mapping="playerByName" action="player"
                  params="[name: cstat.player.name]">${cstat.player.name}</g:link>
        </g:if>
      </td>
      <td>${cstat.player?.rank(game)}</td>

    </g:each>

  </table>
</div>

<h3>
  Character usage spread
</h3>

<div class="table-responsive">
  <table class="table table-striped table-hover table-condensed">
    <thead>
    <tr>
      <td>Statistic</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${game.name()}</td>
      </g:each>
    </tr>
    </thead>
    <tr>
      <td>Series length</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].usageSeries.split(",").size()}</td>
      </g:each>
    </tr>
    <tr>
      <td>percentageInTop50</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].percentageInTop50}</td>
      </g:each>
    </tr>
    <tr>
      <td>percentageInTop100</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].percentageInTop100}</td>
      </g:each>
    </tr>
    <tr>
      <td>rankOfCharAt25Percent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].rankOfCharAt25Percent}</td>
      </g:each>
    </tr>
    <tr>
      <td>rankOfCharAt50Percent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].rankOfCharAt50Percent}</td>
      </g:each>
    </tr>
    <tr>
      <td>rankOfCharAt75Percent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].rankOfCharAt75Percent}</td>
      </g:each>
    </tr>
    <tr>
      <td>rankOfCharAt100Percent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].rankOfCharAt100Percent}</td>
      </g:each>
    </tr>
    <tr>
      <td>sampleSize</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].sampleSize}</td>
      </g:each>
    </tr>
    <tr>
      <td>meanOnScore</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].meanOnScore.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>standardDeviationOnScore</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].standardDeviationOnScore.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>meanOnMain</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].meanOnMain.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>standardDeviationOnMain</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].standardDeviationOnMain.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>meanOnUsage</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].meanOnUsage.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>standardDeviationOnUsage</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].standardDeviationOnUsage.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>meanOnUsagePercent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].meanOnUsagePercent.round(1)}</td>
      </g:each>
    </tr>
    <tr>
      <td>standardDeviationOnUsagePercent</td>
      <g:each in="${gamestats.keySet()}" var="game">
        <td>${gamestats[game].standardDeviationOnUsagePercent.round(1)}</td>
      </g:each>
    </tr>
  </table>
</div>


<g:if test="${SecurityUtils.subject.isPermitted("admin")}">

  Do a new analyse on
  <ol>
    <g:each in="${Version.values()}" var="game">
      <li><g:link controller="stats" action="analyze" params="[game: game.name()]">${game.name()}</g:link></li>
    </g:each>

  </ol>
</g:if>
<script type="text/javascript" charset="utf-8">
  $(document).ready(function ()
                    {
                      $('table[id^="datatable"]').each(function (index)
                                                       {
                                                         $(this).tablecloth({
                                                                              theme: "default",
                                                                              striped: true,
                                                                              sortable: true,
                                                                              condensed: true});
                                                         //$(this).tablesorter({sortList: [[1,1]]})
                                                       })
                    });
</script>
</body>
</html>