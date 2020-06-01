---

layout: playlist
title:  "Mahiro's song recs"
date:   2020-04-05
---


Some songs introduced to me by a physicist.
<!--excerpt-->
{% for album in site.data.mahiro_recs %}
  <article>
    <a href="{{ album.url }}">
      <img src="{{ album.img }}" alt="{{ album.title }} {{ album.artist }}"/>
      <p>{{ album.title }}</p>
    </a>
    <p>by {{ album.artist }}</p>
    {% if release-date %}
      <span class="release-date">{{ album.release_date | date: "%b %-d, %Y" }}</span>
    {% endif %}
  </article>
{% endfor %}

