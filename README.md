# Lyon Crafters

Pour lancer le tout, il vous faut :

  * Installer `elixir`, `node`, `bower` (`npm install -g bower`), `sqlite3`
  * Installer les dépendances avec `mix deps.get` et `cd front; npm install; bower install`
  * Créer et migrer la base de donnée avec `mix ecto.create && mix ecto.migrate`
  * Lancer la compilation des assets avec `cd front; npm run webpack:watch`
  * Lancer le serveur `mix phx.server`

Vous pouvez visiter [`localhost:4000`](http://localhost:4000) depuis votre navigateur.

## Configuration de production

La configuration de production est légèrement différente: `postgres` à la place de `sqlite3`
et bundle de l'application avec `distillery`.

## En savoir plus

  * Elixir : https://elixir-lang.org/getting-started/introduction.html
  * Phoenix : http://phoenixframework.org/docs/overview
  * Purescript : http://www.purescript.org/
  * React : https://reactjs.org/
