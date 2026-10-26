{% extends get_template('mos.tpl','mod/test') %}
{% block content %}
{% if get_variable('missing_audio') %}
<div class="alert alert-danger">Audios à préparer sous systems/ : {{ get_variable('missing_audio')|join(', ') }}. Aucun
    essai ne doit être réalisé avant leur ajout.
</div>
{% else %}
<p>
    Évaluez la continuité du rythme, du timbre et du raccord, pas la familiarité du nom. Suivez toute consigne
    parlée explicite de vérification.
</p>{{ super() }}
{% endif %}
{% endblock %}
