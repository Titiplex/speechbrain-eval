<!doctype html>
<html lang="fr">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="color-scheme" content="light">
    <link rel="icon" href="{{ get_asset('/img/favicon.ico', 'flexeval') }}">
    <title>{{ get_variable('title', default_value='FlexEval') | e }}</title>

    {# Dépendances du moteur : conservées pour les templates existants. #}
    <script src="{{ get_asset('/js/jquery-3.4.1.min.js', 'flexeval') }}"></script>
    <script src="{{ get_asset('/js/jquery-ui.min.js', 'flexeval') }}"></script>
    <link rel="stylesheet" href="{{ get_asset('/css/jquery-ui.min.css', 'flexeval') }}">
    <script src="{{ get_asset('/js/popper.min.js', 'flexeval') }}"></script>
    <link rel="stylesheet" href="{{ get_asset('/css/bootstrap-4.4.1/bootstrap.min.css', 'flexeval') }}">
    <script src="{{ get_asset('/js/bootstrap-4.4.1/bootstrap.min.js', 'flexeval') }}"></script>
    <script src="{{ get_asset('/js/flexeval.js', 'flexeval') }}"></script>
    <link rel="stylesheet" href="{{ get_asset('/css/flexeval.css', 'flexeval') }}">

    {% block head %}{% endblock %}

    <style id="fe-experience-theme">
        :root {color-scheme:light;--navy:#142a43;--blue:#2157d6;--muted:#53647a;--line:#dbe3ed}* {box-sizing:border-box}body{margin:0;background:#f2f5fa;color:var(--navy);font:16px/1.55 system-ui,-apple-system,Segoe UI,sans-serif}header{background:var(--navy);color:white;padding:22px 6vw;display:flex;justify-content:space-between;gap:16px;align-items:center}.brand{font-size:19px;font-weight:750;letter-spacing:.02em}.pill{font-size:12px;border:1px solid #7892ae;padding:5px 10px;border-radius:30px}main{max-width:980px;margin:38px auto;padding:0 22px 50px}h1{font-size:clamp(26px,4vw,36px);line-height:1.2;margin:10px 0 18px}h2{font-size:21px;margin:0 0 12px}p{margin:12px 0}.eyebrow{font-size:12px;letter-spacing:.12em;text-transform:uppercase;font-weight:750;color:var(--blue)}.muted{color:var(--muted)}.panel, .audio-card{background:white;border:1px solid var(--line);border-radius:16px;padding:26px;box-shadow:0 6px 22px #142a4305}.panel{margin-top:22px}.grid{display:grid;grid-template-columns:1fr 1fr;gap:20px;margin:24px 0}.audio-card audio{display:block;width:100%;margin:20px 0}.badge{display:inline-flex;background:#e9efff;color:#214ba6;border-radius:8px;padding:5px 12px;font-weight:700}.notice{padding:16px 20px;background:#e9efff;border-left:4px solid var(--blue);border-radius:5px;margin:20px 0}.training{background:#fff3d7;border-color:#d79a1c}.button, button{display:inline-block;background:var(--blue);color:white;border:0;border-radius:9px;padding:13px 22px;font:inherit;font-weight:650;text-decoration:none;cursor:pointer}button:disabled{opacity:.45;cursor:default}.choice{display:block;padding:13px 16px;border:1px solid var(--line);border-radius:9px;margin:10px 0;cursor:pointer}.choice:has(input:checked) {border-color:var(--blue);background:#f0f4ff}input[type=radio], input[type=checkbox] {accent-color:var(--blue);margin-right:10px}select, textarea{width:100%;font:inherit;padding:12px;border:1px solid #b9c6d6;border-radius:8px;background:white;color:var(--navy)}select{margin:12px 0}textarea{min-height:100px}label{font-weight:550}.status{font-size:13px;color:var(--muted)}.actions{display:flex;align-items:center;gap:20px;flex-wrap:wrap;margin-top:25px}.progress{height:6px;background:#e1e7f0;border-radius:9px;overflow:hidden;margin:18px 0 26px}.progress span{display:block;height:100%;background:var(--blue)}.facts{display:flex;gap:12px;flex-wrap:wrap;margin:22px 0}.facts span{border:1px solid var(--line);border-radius:9px;padding:8px 12px;background:white;font-size:14px}footer{font-size:12px;color:var(--muted);padding-top:30px}a{color:var(--blue)}:focus-visible

        {outline:3px solid #70a4ff;outline-offset:3px}@media (max-width: 620px)

        {.grid{grid-template-columns:1fr}header{padding:18px 22px}.panel,.audio-card{padding:20px}main{margin-top:25px}}

        #fe-experience {
            margin: 0;
            background: #f2f5fa;
            color: #142a43;
            font: 16px/1.55 system-ui, -apple-system, "Segoe UI", sans-serif;
        }

        #fe-experience *, #fe-experience *::before, #fe-experience *::after {
            box-sizing: border-box;
        }

        #fe-experience .fe-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 18px 28px;
            flex-wrap: wrap;
            margin: 0;
            padding: 20px max(24px, calc((100% - 1060px) / 2));
            background: #142a43;
            color: white;
        }

        #fe-experience .fe-heading {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 10px 20px;
            min-width: 0;
        }

        #fe-experience .fe-header .brand, #fe-experience .fe-header .display-1 {
            margin: 0;
            color: white;
            font-size: 20px;
            font-weight: 750;
            line-height: 1.35;
            letter-spacing: .01em;
            overflow-wrap: anywhere;
        }

        #fe-experience .fe-header .pill {
            color: #e8eff7;
            border-color: #71859e;
            font-size: 12px;
            line-height: 1.5;
        }

        #fe-experience .fe-account {
            min-width: 0;
            font-size: 12px;
            color: #c7d3e1;
        }

        #fe-experience .fe-account p {
            display: flex;
            align-items: center;
            flex-wrap: wrap;
            gap: 8px 12px;
            margin: 0;
        }

        #fe-experience .fe-session-id {
            display: inline-block;
            max-width: 24ch;
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
            vertical-align: middle;
        }

        #fe-experience .fe-account a {
            color: #e8eff7;
            text-decoration: underline;
            text-underline-offset: 3px;
        }

        #fe-experience .fe-header-description {
            width: 100%;
            margin: 0;
            color: #c7d3e1;
            font-size: 14px;
        }

        #fe-experience .fe-main {
            display: block;
            width: 100%;
            max-width: 1060px;
            margin: 38px auto 0;
            padding: 0 24px 30px;
            min-width: 0;
        }

        #fe-experience .fe-main > :first-child {
            margin-top: 0;
        }

        #fe-experience .fe-main h1 {
            color: #142a43;
            font-size: clamp(26px, 4vw, 36px);
            line-height: 1.2;
            font-weight: 700;
            margin: 10px 0 18px;
            letter-spacing: -.025em;
        }

        #fe-experience .fe-main h2, #fe-experience .bd-content-title {
            color: #142a43;
            font-size: 23px;
            line-height: 1.4;
            font-weight: 650;
            margin: 0 0 20px;
        }

        #fe-experience .bd-content-title > img {
            width: 14px;
            height: 14px;
            margin: 0 7px 3px 0;
        }

        #fe-experience p {
            margin: 12px 0;
        }

        #fe-experience .muted, #fe-experience .text-muted {
            color: #53647a;
        }

        #fe-experience .eyebrow {
            color: #2157d6;
            font-size: 12px;
            font-weight: 750;
            letter-spacing: .12em;
            text-transform: uppercase;
        }

        #fe-experience a {
            color: #2157d6;
            text-underline-offset: 3px;
        }

        #fe-experience a:hover {
            color: #173f9c;
        }

        #fe-experience .panel, #fe-experience .audio-card {
            min-width: 0;
            background: white;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            padding: 26px;
            box-shadow: 0 6px 22px #142a4305;
        }

        #fe-experience .grid {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            margin: 24px 0;
        }

        #fe-experience .badge {
            display: inline-flex;
            background: #e9efff;
            color: #214ba6;
            border-radius: 8px;
            padding: 5px 12px;
            font-size: 14px;
            line-height: 1.5;
            font-weight: 700;
        }

        #fe-experience .progress {
            display: block;
            height: 6px;
            background: #e1e7f0;
            border-radius: 9px;
            overflow: hidden;
            margin: 18px 0 26px;
        }

        #fe-experience .progress > span, #fe-experience .progress-bar {
            display: block;
            height: 100%;
            background: #2157d6;
        }

        /* Les boutons de fermeture ne doivent pas hériter du gros bouton bleu. */
        #fe-experience .btn, #fe-experience .button,
        #fe-experience button[type="submit"], #fe-experience input[type="submit"] {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            min-height: 46px;
            padding: 12px 20px;
            border: 1px solid transparent;
            border-radius: 9px;
            font: inherit;
            font-size: 15px;
            line-height: 1.5;
            font-weight: 650;
            text-decoration: none;
            cursor: pointer;
            white-space: normal;
        }

        #fe-experience .btn-primary, #fe-experience .button,
        #fe-experience button[type="submit"]:not(.btn), #fe-experience input[type="submit"]:not(.btn) {
            background: #2157d6;
            border-color: #2157d6;
            color: white;
        }

        #fe-experience .btn-primary:hover, #fe-experience .button:hover,
        #fe-experience button[type="submit"]:not(.btn):hover {
            background: #1946b1;
            border-color: #1946b1;
            color: white;
        }

        #fe-experience .btn-primary:not(:disabled):not(.disabled):active {
            background: #1946b1;
            border-color: #1946b1;
        }

        #fe-experience .btn-primary:focus {
            box-shadow: 0 0 0 3px #2157d633;
        }

        #fe-experience button:disabled, #fe-experience input:disabled, #fe-experience .btn.disabled {
            opacity: .45;
            cursor: not-allowed;
        }

        #fe-experience .fe-main > a {
            display: inline-flex;
            margin-top: 12px;
            padding: 12px 20px;
            border-radius: 9px;
            background: #2157d6;
            color: white;
            text-decoration: none;
            font-weight: 650;
        }

        #fe-experience .actions {
            display: flex;
            align-items: center;
            gap: 18px;
            flex-wrap: wrap;
            margin-top: 25px;
        }

        #fe-experience fieldset {
            min-width: 0;
        }

        #fe-experience .form-group {
            min-width: 0;
            margin-bottom: 22px;
        }

        #fe-experience legend.col-form-label {
            float: none;
            width: 100%;
            max-width: 100%;
            padding: 0;
            margin: 0 0 18px;
            font-size: 16px;
            line-height: 1.6;
        }

        #fe-experience .form-example {
            margin: 24px 0 0;
            padding: 26px;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            background: white;
        }

        #fe-experience .form-example:has(audio), #fe-experience .form-example:has(video) {
            padding: 0;
            border: 0;
            border-radius: 0;
            background: transparent;
        }

        #fe-experience .form-example > fieldset {
            padding: 0;
            border: 0;
            margin: 0 0 26px;
        }

        #fe-experience label {
            color: #142a43;
            font-weight: 550;
        }

        #fe-experience .form-group > label {
            display: block;
            width: 100%;
        }

        #fe-experience .form-control, #fe-experience select, #fe-experience textarea,
        #fe-experience input[type="text"], #fe-experience input[type="email"],
        #fe-experience input[type="number"], #fe-experience input[type="tel"],
        #fe-experience input[type="password"], #fe-experience input[type="url"] {
            display: block;
            width: 100%;
            max-width: 100%;
            height: auto;
            min-height: 46px;
            padding: 11px 12px;
            border: 1px solid #b9c6d6;
            border-radius: 8px;
            background: white;
            color: #142a43;
            font: inherit;
            line-height: 1.5;
        }

        #fe-experience select.form-control:not([size]):not([multiple]) {
            height: 48px;
        }

        #fe-experience select {
            margin: 12px 0 0;
        }

        #fe-experience textarea {
            min-height: 110px;
            resize: vertical;
        }

        #fe-experience .form-control:focus {
            border-color: #2157d6;
            box-shadow: 0 0 0 3px #2157d61a;
        }

        #fe-experience .form-check {
            display: grid;
            grid-template-columns: 20px minmax(0, 1fr);
            align-items: start;
            gap: 10px;
            padding: 14px 16px;
            margin: 10px 0;
            border: 1px solid #dbe3ed;
            border-radius: 9px;
            background: white;
        }

        #fe-experience .form-check-input {
            position: static;
            width: 17px;
            height: 17px;
            margin: 4px 0 0;
            accent-color: #2157d6;
            cursor: pointer;
        }

        #fe-experience .form-check-label {
            display: block;
            width: 100%;
            min-width: 0;
            margin: 0;
            cursor: pointer;
        }

        #fe-experience .form-check:has(> input:checked), #fe-experience .choice:has(input:checked) {
            border-color: #2157d6;
            background: #f0f4ff;
        }

        #fe-experience .form-check:focus-within {
            outline: 2px solid #70a4ff;
            outline-offset: 2px;
        }

        #fe-experience audio {
            display: block;
            width: 100%;
            max-width: 100%;
            height: 44px;
            margin: 16px 0;
        }

        #fe-experience video {
            display: block;
            width: 100%;
            max-height: 450px;
            border-radius: 9px;
            background: #142a43;
        }

        #fe-experience .status, #fe-experience [role="status"] {
            font-size: 13px;
            color: #53647a;
        }

        #fe-experience .form-example > fieldset > .form-group:has(> .form-check audio) {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            margin: 24px 0;
            counter-reset: fe-audio;
        }

        #fe-experience .form-check:has(audio) {
            counter-increment: fe-audio;
            padding: 24px;
            margin: 0;
            border-radius: 16px;
            box-shadow: 0 6px 22px #142a4305;
        }

        #fe-experience .form-check:has(audio) .form-check-label::before {
            content: "Audio " counter(fe-audio, upper-alpha);
            display: inline-flex;
            padding: 5px 12px;
            border-radius: 8px;
            background: #e9efff;
            color: #214ba6;
            font-size: 14px;
            font-weight: 700;
        }

        #fe-experience .form-example > fieldset:has(> .form-group > select) {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
            counter-reset: fe-audio;
        }

        #fe-experience .form-example > fieldset > .form-group:has(> select) {
            counter-increment: fe-audio;
            padding: 26px;
            margin: 0;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            background: white;
        }

        #fe-experience .form-group:has(> select) > label:has(audio)::before {
            content: "Audio " counter(fe-audio, upper-alpha);
            display: inline-flex;
            padding: 5px 12px;
            border-radius: 8px;
            background: #e9efff;
            color: #214ba6;
            font-size: 14px;
            font-weight: 700;
        }

        #fe-experience .form-example fieldset > fieldset {
            padding: 24px;
            margin: 20px 0;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            background: white;
        }

        #fe-experience input[type="range"], #fe-experience .form-control-range {
            display: block;
            width: 100%;
            max-width: 100%;
            margin: 18px 0;
            padding: 0;
            accent-color: #2157d6;
            cursor: pointer;
        }

        #fe-experience #abx-form > fieldset:first-of-type {
            display: grid;
            grid-template-columns: repeat(2, minmax(0, 1fr));
            gap: 20px;
        }

        #fe-experience #abx-form > fieldset:first-of-type > .form-group {
            padding: 24px;
            margin: 0;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            background: white;
        }

        #fe-experience #abx-form > fieldset:first-of-type > .form-group:last-child {
            grid-column: 1 / -1;
        }

        #fe-experience #abx-form > fieldset:first-of-type > .form-group > p {
            margin: 0;
            font-weight: 700;
        }

        #fe-experience #abx-form > fieldset:has(> .form-check) {
            padding: 24px;
            border: 1px solid #dbe3ed;
            border-radius: 16px;
            background: white;
        }

        #fe-experience .alert {
            padding: 16px 20px;
            margin: 20px 0;
            border-radius: 9px;
            font-size: 14px;
            line-height: 1.55;
        }

        #fe-experience .alert-heading {
            font-size: 17px;
            font-weight: 650;
        }

        #fe-experience .alert p:last-of-type {
            margin-bottom: 0;
        }

        #fe-experience .alert-warning {
            color: #725315;
            background: #fff3d7;
            border-color: #e4c781;
        }

        #fe-experience .alert-danger {
            color: #8d3434;
            background: #fff0ef;
            border-color: #e7c2bd;
        }

        #fe-experience .alert-dismissible {
            position: relative;
            padding-right: 48px;
        }

        #fe-experience .alert-dismissible .close {
            position: absolute;
            top: 0;
            right: 0;
            display: block;
            min-height: 0;
            padding: 14px 16px;
            border: 0;
            border-radius: 0;
            background: transparent;
            color: inherit;
            font-size: 24px;
            line-height: 1;
            text-shadow: none;
            opacity: .7;
            cursor: pointer;
        }

        #fe-experience .popover {
            font-family: inherit;
            border-color: #dbe3ed;
            border-radius: 8px;
        }

        #fe-experience .fe-footer {
            max-width: 1060px;
            margin: 0 auto;
            padding: 0 24px 30px;
            color: #53647a;
            font-size: 12px;
        }

        #fe-experience .fe-footer-inner {
            border-top: 1px solid #dbe3ed;
            padding-top: 24px;
        }

        #fe-experience .fe-institutions {
            display: flex;
            align-items: center;
            justify-content: center;
            flex-wrap: wrap;
            gap: 24px;
            margin: 0 0 18px;
        }

        #fe-experience .fe-institutions a {
            display: inline-flex;
            align-items: center;
        }

        #fe-experience .fe-institutions img {
            display: block;
            width: auto;
            height: auto;
            max-width: 155px;
            max-height: 34px;
            object-fit: contain;
        }

        #fe-experience .fe-footer-meta {
            text-align: center;
        }

        #fe-experience .fe-footer-meta p {
            margin: 5px 0;
        }

        #fe-experience .fe-footer a {
            color: #53647a;
        }

        #fe-experience .fe-footer a:hover {
            color: #2157d6;
        }

        #fe-experience .fe-main:focus {
            outline: none;
        }

        #fe-experience :focus-visible {
            outline: 3px solid #70a4ff;
            outline-offset: 3px;
        }

        #fe-experience .fe-skip-link {
            position: fixed;
            width: 1px;
            height: 1px;
            padding: 0;
            overflow: hidden;
            clip-path: inset(50%);
            white-space: nowrap;
        }

        #fe-experience .fe-skip-link:focus {
            top: 10px;
            left: 12px;
            z-index: 2000;
            width: auto;
            height: auto;
            padding: 10px 16px;
            border-radius: 8px;
            background: white;
            color: #142a43;
            clip-path: none;
        }

        @media (max-width: 700px) {
            #fe-experience .fe-header {
                padding: 18px 22px;
                gap: 14px;
            }

            #fe-experience .fe-main {
                margin-top: 26px;
                padding: 0 18px 26px;
            }

            #fe-experience .grid,
            #fe-experience .form-example > fieldset > .form-group:has(> .form-check audio),
            #fe-experience .form-example > fieldset:has(> .form-group > select),
            #fe-experience #abx-form > fieldset:first-of-type {
                grid-template-columns: minmax(0, 1fr);
            }

            #fe-experience .panel, #fe-experience .audio-card,
            #fe-experience .form-check:has(audio),
            #fe-experience .form-example > fieldset > .form-group:has(> select),
            #fe-experience #abx-form > fieldset:first-of-type > .form-group {
                padding: 20px;
            }

            #fe-experience .fe-footer {
                padding: 0 18px 24px;
            }

            #fe-experience .fe-session-id {
                max-width: 23ch;
            }
        }

        @media (prefers-reduced-motion: reduce) {
            #fe-experience *, #fe-experience *::before, #fe-experience *::after {
                transition: none;
                scroll-behavior: auto;
            }
        }
    </style>
    {% block styles %}{% endblock %}
</head>

<body id="fe-experience" class="fe-theme {% block body_class %}{% endblock %}">
<a class="fe-skip-link" href="#fe-main">Aller au contenu</a>
<header class="fe-header">
    <div class="fe-heading">
        {% block header %}
        <span class="brand">{{ get_variable('title', default_value='FlexEval') | e }}</span>
        <span class="pill">{{ (get_variable('protocol_label') or get_variable('subtitle') or 'Évaluation audio') | e }}</span>
        {% endblock %}
    </div>
    <div class="fe-account">
        {% block userintel %}
        {% if auth.is_connected %}
        <p><span class="fe-session-id" title="{{ auth.user.pseudo | e }}">{{ auth.user.pseudo | e }}</span>
            <a href="{{ auth.url_deco }}">Se déconnecter</a></p>
        {% endif %}
        {% endblock %}
    </div>
    {% if get_variable('description') %}
    <p class="fe-header-description">{{ get_variable('description') | e }}</p>
    {% endif %}
</header>

<main id="fe-main" class="fe-main" tabindex="-1">
    {% block content %}{% endblock %}
</main>

<footer class="fe-footer">
    <div class="fe-footer-inner">
        <div class="fe-institutions">
            {% block footer %}
            <a href="http://www.irisa.fr" target="_blank" rel="noopener noreferrer">
                <img src="{{ get_asset('/img/logo/irisa.png', 'flexeval') }}" alt="IRISA" width="155">
            </a>
            <a href="http://www-expression.irisa.fr" target="_blank" rel="noopener noreferrer">
                <img src="{{ get_asset('/img/logo/expression.png', 'flexeval') }}" alt="Équipe Expression" width="155">
            </a>
            {% endblock %}
        </div>
        <div class="fe-footer-meta">
            <p>{% if get_variable('authors') %}Réalisé par {{ get_variable('authors') | e }}. {% endif %}
                <a href="{{ make_url('/legal_terms') }}">Confidentialité et conditions d'utilisation</a></p>
            <p>Propulsé par <a href="https://gitlab.inria.fr/expression/tools/FlexEval">FlexEval</a>.</p>
            {% block bottomlink %}
            <p>{% if module_class == 'AdminModule' %}<a href="{{ make_url('/') }}">Quitter l'administration</a>
                {% else %}<a href="{{ make_url('/admin/') }}">Administration</a>{% endif %}</p>
            {% endblock %}
        </div>
    </div>
</footer>
{% block scripts %}{% endblock %}
</body>
</html>
