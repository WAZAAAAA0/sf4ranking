<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
  <meta name="layout" content="artificial"/>
  <title>SRK data - Player Search</title>
</head>

<body>
<g:if test="${flash.message}">
  <div class="alert alert-warning">${flash.message}</div>
</g:if>

<h2>${players? players.size() : "0"} players matching '${query}'</h2>
<g:if test="${!(players.isEmpty())}">
<div class="table-responsive">
  <table class="tablehead" id="datatable1">
    <thead>
    <tr class="stathead">
      <th>Name</th>
      <th>Twitter</th>
      <th>Real name</th>
      <th>Known as</th>
      <th>Country</th>
      <th>Main Game</th>
      <th>Smash id</th>
    </tr>
    </thead>
    <g:each in="${players}" var="player">

      <tr>
        <td><g:link mapping="playerByName" controller="rankings" action="playerByName"
                    params="[name: player.name]">${player.name}</g:link></td>
        <td>${player.twitter}</td>
        <td>${player.realname}</td>
        <td>${player.alias}</td>
        <td>${player.countryCode}</td>
        <td>${player.mainGame}</td>
        <td>${player.smashId}</td>
      </tr>
    </g:each>

  </table>
</div>
</g:if>



<h2>${alikes? alikes.size() : "0"} players who sound like '${query}'</h2>

<div class="table-responsive">
  <table class="tablehead" id="datatable2">
    <thead>
    <tr class="stathead">
      <th>Name</th>
      <th>Twitter</th>
      <th>Real name</th>
      <th>Known as</th>
      <th>Country</th>
      <th>Main Game</th>
    </tr>
    </thead>
    <g:each in="${alikes}" var="player">

      <tr>
        <td><g:link mapping="playerByName" controller="rankings" action="playerByName"
                    params="[name: player.name]">${player.name}</g:link></td>
        <td>${player.twitter}</td>
        <td>${player.realname}</td>
        <td>${player.alias}</td>
        <td>${player.countryCode}</td>
        <td>${player.mainGame}</td>
      </tr>
    </g:each>

  </table>
</div>

</body>
</html>