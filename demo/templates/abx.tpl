{% extends get_template('ab.tpl', 'mod/test') %}

{% block content %}

{% if get_variable("intro_step", default_value=False) %}
<div class="alert alert-warning alert-dismissible fade show" role="alert">
    <h4 class="alert-heading">Phase d'entraînement</h4>
    <p>Ces réponses seront identifiées comme des réponses d'entraînement.</p>
    <button type="button" class="close" data-dismiss="alert" aria-label="Fermer">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
{% endif %}

{% if not get_variable("intro_step", default_value=False) and get_variable("step") == 1 %}
<div class="alert alert-danger alert-dismissible fade show" role="alert">
    <h4 class="alert-heading">Début de l'évaluation</h4>
    <p>Les réponses suivantes seront utilisées pour l'évaluation.</p>
    <button type="button" class="close" data-dismiss="alert" aria-label="Fermer">
        <span aria-hidden="true">&times;</span>
    </button>
</div>
{% endif %}

<h2 class="bd-content-title">
    <img src="{{ get_asset('/img/svg_icon/chevron-right.svg', 'flexeval') }}" alt=">"/>
    {{ get_variable("subtitle", default_value="Test ABX") }}
    — étape {{ get_variable("step") }} sur {{ get_variable("max_steps") }}
</h2>

{% set samples = get_variable("syssamples") %}

{% if samples | length != 2 %}
<div class="alert alert-danger" role="alert">
    Le test ABX nécessite exactement deux systèmes audio dans tests.json.
</div>
{% else %}

{% if get_variable('abx_target') is none %}
{% set trial_ids = samples | map(attribute='ID') | sort | list %}
{% set trial = session.get('flexeval_abx_trial') %}
{% if trial is none or trial.get('ids') != trial_ids %}
{% set target = samples | random %}
{% set trial = {
'ids': trial_ids,
'a': samples[0].ID,
'b': samples[1].ID,
'x': target.ID
} %}
{% set unused = session.update({'flexeval_abx_trial': trial}) %}
{% endif %}

{% set sample_a = samples[0] if samples[0].ID == trial['a'] else samples[1] %}
{% set sample_b = samples[1] if samples[0].ID == trial['a'] else samples[0] %}
{% else %}
{% set sample_a = samples[0] %}
{% set sample_b = samples[1] %}
{% set target_name = get_variable('abx_target') %}
{% if target_name is none %}
{% set target = samples|random %}
{% set target_name = target.system_name %}
{% endif %}
{% set trial = {'x': sample_a.ID if target_name == sample_a.system_name else sample_b.ID} %}
{% endif %}
{% set content_a, mimetype_a = sample_a.get(num=0) %}
{% set content_b, mimetype_b = sample_b.get(num=0) %}
{% set content_x = content_a if trial['x'] == sample_a.ID else content_b %}

{% if mimetype_a != 'audio' or mimetype_b != 'audio' %}
<div class="alert alert-danger" role="alert">
    La première colonne de chaque système doit désigner un fichier audio lisible.
</div>
{% else %}

{% set field_name = get_variable("field_name", name="ABX_choice", syssamples=[sample_a, sample_b]) %}

<form id="abx-form" action="./save" method="post" enctype="multipart/form-data" class="form-example">
    <p id="abx-instructions">
        Écoutez A, B et X. L'extrait X est une copie de A ou de B.
        Indiquez auquel il correspond, même si vous hésitez.
        Vous pouvez réécouter les extraits avant de répondre.
    </p>

    <fieldset class="form-group" aria-describedby="abx-instructions">
        <legend class="col-form-label"><strong>Extraits à écouter</strong></legend>

        <div class="form-group">
            <p id="abx-label-a"><strong>Extrait A</strong></p>
            <audio id="abx-a" controls preload="metadata" aria-labelledby="abx-label-a">
                <source src="{{ content_a }}">
                Votre navigateur ne prend pas en charge la lecture audio.
            </audio>
        </div>

        <div class="form-group">
            <p id="abx-label-b"><strong>Extrait B</strong></p>
            <audio id="abx-b" controls preload="metadata" aria-labelledby="abx-label-b">
                <source src="{{ content_b }}">
                Votre navigateur ne prend pas en charge la lecture audio.
            </audio>
        </div>

        <div class="form-group">
            <p id="abx-label-x"><strong>Extrait X</strong></p>
            <audio id="abx-x" controls preload="metadata" aria-labelledby="abx-label-x">
                <source src="{{ content_x }}">
                Votre navigateur ne prend pas en charge la lecture audio.
            </audio>
        </div>
    </fieldset>

    <fieldset class="form-group">
        <legend class="col-form-label"><strong>Question :</strong> X correspond-il à A ou à B ?</legend>

        <div class="form-check">
            <input class="form-check-input" type="radio" name="{{ field_name }}" id="abx-choice-a"
                   value="{{ sample_a.ID }}" required>
            <label class="form-check-label" for="abx-choice-a">X correspond à A</label>
        </div>

        <div class="form-check">
            <input class="form-check-input" type="radio" name="{{ field_name }}" id="abx-choice-b"
                   value="{{ sample_b.ID }}" required>
            <label class="form-check-label" for="abx-choice-b">X correspond à B</label>
        </div>
    </fieldset>

    <input type="hidden" name="ABX_reference_A" value="{{ sample_a.ID }}">
    <input type="hidden" name="ABX_reference_B" value="{{ sample_b.ID }}">
    <input type="hidden" name="ABX_target" value="{{ trial['x'] }}">

    <p id="abx-playback-status" role="status" aria-live="polite">
        Terminez la lecture des trois extraits avant de valider votre réponse.
    </p>
    <noscript><p>JavaScript doit être activé pour effectuer ce test.</p></noscript>

    <button id="abx-submit" type="submit" class="btn btn-primary" disabled>Valider</button>
</form>

<script>
    (function () {
        "use strict";

        const form = document.getElementById("abx-form");
        const players = Array.prototype.slice.call(form.querySelectorAll("audio"));
        const submit = document.getElementById("abx-submit");
        const status = document.getElementById("abx-playback-status");
        const completed = Object.create(null);
        let playbackError = false;

        function allCompleted() {
            return !playbackError && players.every(function (player) {
                return completed[player.id] === true;
            });
        }

        players.forEach(function (player) {
            player.addEventListener("play", function () {
                players.forEach(function (other) {
                    if (other !== player) {
                        other.pause();
                    }
                });
            });

            player.addEventListener("ended", function () {
                completed[player.id] = true;
                submit.disabled = !allCompleted();
                if (allCompleted()) {
                    status.textContent = "Vous pouvez sélectionner votre réponse et la valider.";
                }
            });

            player.addEventListener("error", function () {
                playbackError = true;
                submit.disabled = true;
                status.textContent = "Un extrait n'a pas pu être lu. Rechargez la page pour réessayer.";
            });
        });

        form.addEventListener("submit", function (event) {
            if (!allCompleted()) {
                event.preventDefault();
                if (!playbackError) {
                    status.textContent = "Terminez la lecture de A, B et X avant de valider.";
                }
            }
        });
    }());
</script>

{% endif %}
{% endif %}

{% endblock %}
