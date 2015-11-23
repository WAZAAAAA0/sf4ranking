<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="overviews"/>
  <title>Fighting Games World Rankings - Capcom Pro Tour Character Stats</title>
</head>

<body>
<h2>Character Statistics in Capcom Pro Tour</h2>
Statistics drawn from past Capcom Pro Tour tournaments. They reflect the characters we will likely see in the Capcom Cup finals and who pklays them, as well as overall statistics on what characters were used to compete in the Capcom Pro Tour.


<g:if test="${byMainCharacter32}">
    <h3 class="tournament">Main character occurence of top32</h3>
    <div class="table-responsive">
        <table class="tablehead" id="datatable2">
            <thead>
            <tr class="stathead">
                <th>Character</th>
                <th>Occurence</th>
                <th>Used by</th>
            </tr>
            </thead>
            <g:each in="${byMainCharacter32}" var="t">
                <tr>
                    <td>${t.key?.value}</td>
                    <td>${t.value.size()}</td>
                    <td>${t.value.collect{ it.name}.join(", ")}</td>
                </tr>
            </g:each>
        </table>
    </div>
    A total of <b>${byMainCharacter32.size()} </b>have been used as main by the current best 32 CPT players.  <br/>
    Characters not used as main are: <b>${notIn.join(", ")}</b>
</g:if>

<g:if test="${secondary32}">
    <h3 class="tournament">All character occurences of top32</h3>
    <div class="table-responsive">
        <table class="tablehead" id="datatable5">
            <thead>
            <tr class="stathead">
                <th>Character</th>
                <th>Occurence</th>
                <th>Used by</th>
            </tr>
            </thead>
            <g:each in="${secondary32}" var="t">
                <tr>
                    <td>${t.key?.value}</td>
                    <td>${t.value.size()}</td>
                    <td>${t.value.collect{ it.name}.join(", ")}</td>
                </tr>
            </g:each>
        </table>
    </div>
    A total of <b>${byMainCharacter32.size()} </b>have been used as main by the current best 32 CPT players. <br/>
    Characters not used at all are: <b>${notInAll.join(", ")}</b>
</g:if>




<g:if test="${charToCount}">
    <h3 class="tournament">Characters seen in all CPT tournaments</h3>
    <div class="table-responsive">
        <table class="tablehead" id="datatable3">
            <thead>
            <tr class="stathead">
                <th>Character</th>
                <th>Occurence</th>
            </tr>
            </thead>
            <g:each in="${charToCount}" var="t">
                <tr>
                    <td>${t.key?.value}</td>
                    <td>${t.value}</td>
                </tr>
            </g:each>
        </table>
    </div>
    A total of <b>${charToCount.size()} </b>have been used as main or secondary by all Capcom Pro Tour tournament players.
</g:if>

<g:render template="/templates/prettify"/>

</body>
</html>