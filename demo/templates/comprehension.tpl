{% extends get_template('base.tpl','flexeval') %}{% block content %}
<h2>Compréhension de la consigne</h2><p>Pour évaluer l’intégration du nom, que faut-il juger ?</p>
<form id="understanding" action="./save" method="post"><input type="hidden" name="attempts" value="0"><input
            type="hidden" name="first_choice" value="">
    {% for value,label in [('raccord','La continuité du rythme, du timbre et du raccord'),('familiarity','Si le nom est habituel ou familier'),('meaning','Si le nom convient au sens de la phrase')] %}
    <label class="choice"><input type="radio" name="criterion" value="{{ value }}" required>{{ label }
        }</label>{% endfor %}<p id="clarification" role="status"></p>
    <button type="submit">Continuer</button>
</form>
<script>document.getElementById('understanding').addEventListener('submit', function (e){const choice=this.querySelector('[name=criterion]:checked');if(!choice)return;const first=this.querySelector('[name=first_choice]');if(!first.value)first.value=choice.value;const attempts=this.querySelector('[name=attempts]');attempts.value=Number(attempts.value)+1;if(choice.value!=='raccord'){e.preventDefault();document.getElementById('clarification').textContent='Il faut juger le raccord acoustique. Un pseudonyme inhabituel peut être bien intégré. Relisez puis réessayez.';}});</script>
{% endblock %}