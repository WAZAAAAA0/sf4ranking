<%@ page import="org.apache.shiro.SecurityUtils; be.bbr.sf4ranking.Version; be.bbr.sf4ranking.TournamentFormat; be.bbr.sf4ranking.TournamentType; be.bbr.sf4ranking.ScoringSystem" contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="overviews"/>
    <title>Player comparison results</title>
</head>

<body>

<h2>Player statistics of ${p1.name} versus ${p2.name}</h2>
<g:each in="${games}" var="comparison" status="i">
    <h3>${comparison.game}</h3>

    <div class="table-responsive">
        <table class="tablehead" id="datatable${i}">
            <thead>
            <tr class="stathead">
                <td>Statistic</td>
                <td><g:link controller="rankings" action="player" params="[id: p1.id]">${p1.name}</g:link></td>
                <td><g:link controller="rankings" action="player" params="[id: p2.id]">${p2.name}</g:link></td>
                <td>Diff</td>
                <td>Verdict</td>
            </tr>
            </thead>
            <tr>
                <td>Tournament Listings</td>
                <td>${comparison.listingsP1}</td>
                <td>${comparison.listingsP2}</td>
                <td>${comparison.listingsDiff}</td>
                <td class="${comparison.css(comparison.listingsResult)}">${comparison.listingsResult}</td>
            </tr>
            <tr>
                <td>Tournament Wins</td>
                <td>${comparison.tournamentWinsP1}</td>
                <td>${comparison.tournamentWinsP2}</td>
                <td>${comparison.tournamentWinsDiff}</td>
                <td class="${comparison.css(comparison.tournamentWinsResults)}">${comparison.tournamentWinsResults}</td>
            </tr>
            <tr>
                <td>Beat other player</td>
                <td>${comparison.outrankP1}</td>
                <td>${comparison.outrankP2}</td>
                <td>${comparison.outrankDiff}</td>
                <td class="${comparison.css(comparison.outrankResult)}">${comparison.outrankResult}</td>
            </tr>
            <tr>
                <td>Actual Score</td>
                <td>${comparison.scoreP1}</td>
                <td>${comparison.scoreP2}</td>
                <td>${comparison.scoreDiff}</td>
                <td class="${comparison.css(comparison.scoreResult)}">${comparison.scoreResult}</td>
            </tr>
            <tr>
                <td>Total Score</td>
                <td>${comparison.totalscoreP1}</td>
                <td>${comparison.totalscoreP2}</td>
                <td>${comparison.totalscoreDiff}</td>
                <td class="${comparison.css(comparison.totalscoreResult)}">${comparison.totalscoreResult}</td>
            </tr>
            <tr>
                <td>Current Ranking</td>
                <td>${comparison.rankP1}</td>
                <td>${comparison.rankP2}</td>
                <td>${comparison.rankDiff}</td>
                <td class="${comparison.css(comparison.rankResult)}">${comparison.rankResult}</td>
            </tr>
        </table>
    </div>

</g:each>

<h3>
    Non matching listings
</h3>
<g:if test="${p1Exclusive}">
    ${p1.name} has exclusive rankings in ${p1Exclusive.value.join(", ")}<br/>
</g:if>
<g:if test="${p2Exclusive}">
    ${p2.name} has exclusive rankings in ${p2Exclusive.value.join(", ")}<br/>
</g:if>
<h3>Compare versus other</h3>
<fieldset class="form">
    <g:form action="compareResults" controller="stats" name="compareForm" class="form-inline" method="GET">
        <label for="p1">
            <g:message message="Compare player"/>
        </label>

        <div class="form-group">
            <input id="p1" class="form-control" placeholder="Find a Player" name="p1" value="${p1?.name}">
        </div>
        <label for="p2">
            <g:message message="to"/>
        </label>

        <div class="form-group">
            <input id="p2" class="form-control" placeholder="Find a Player" name="p2" value="${p2?.name}">
        </div>
        <button type="submit" class="btn btn-primary">Submit</button>
    </g:form>
</fieldset>
<br/>

<script type="text/javascript" charset="utf-8">
    $(document).ready(function () {
        $('table[id^="datatable"]').each(function (index) {
            console.log("test " + index);
            try {
                $(this).tablecloth({
                    theme: "default",
                    striped: true,
                    condensed: true
                });
            }
            catch (err) {
            }
            console.log("test done " + index);
            //$(this).tablesorter({sortList: [[1,1]]})
        })
    });
</script>
<script>
    $(function () {
        $("#p1").autocomplete({
            source: "${createLink(action: 'autocompletePlayer', controller: 'rankings')}",
            minLength: 3,
            select: function (event, ui) {
                if (ui.item) $("#p1").val(ui.item.value);

            }
        });
    });
</script>
<script>
    $(function () {
        $("#p2").autocomplete({
            source: "${createLink(action: 'autocompletePlayer', controller: 'rankings')}",
            minLength: 3,
            select: function (event, ui) {
                if (ui.item) $("#p2").val(ui.item.value);
            }
        });
    });
</script>
</body>
</html>