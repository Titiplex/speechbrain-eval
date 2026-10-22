<nav aria-label="Rapports statistiques">
    {% for page in get_variable("navigation") %}
    <a href="?report={{ page.id }}"
            {% if page.id == get_variable("report_id") %}
       aria-current="page"
            {% endif %}>
        {{ page.title }}
    </a>
    {% endfor %}
</nav>