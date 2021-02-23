import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:kt_dart/collection.dart';

void main() => runApp(MyApp());

//configuration and details
final String pokemon_authority = 'pokeapi.co';
final String poke_api_base = '/api/v2';
String getPokemonImage(pokeId) =>
    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$pokeId.png';

class PokeAPI {
  PokeAPI();

  Client _client = Client();

  static final String baseUrl = poke_api_base;

  Uri pokemonList() {
    return Uri.https(pokemon_authority, '$poke_api_base/pokemon');
  }

  Uri pokemonDetail(pokemonName) {
    return Uri.https(pokemon_authority, '$poke_api_base/pokemon/$pokemonName');
  }

  Future<KtList<Pokemon>> getPokemonList([int offset = 0]) async {
    final perPage = 151;
    final offset = 0;
    final Response response =
        await _client.get('${pokemonList()}?offset=$offset&limit=$perPage');
    final decoded = jsonDecode(response.body);
    final results = decoded['results'];

    return listFrom(results).map((item) => Pokemon.fromJson(item));
  }

  Future<PokeDetail> getPokemonDetail([String pokemonName = 'pikachu']) async {
    final Response response = await _client.get(pokemonDetail(pokemonName));
    final decoded = jsonDecode(response.body);
    return PokeDetail.fromJson(decoded);
  }
}

final pokeApi = new PokeAPI();

class Detail extends StatefulWidget {
  String id;
  String name;
  String image;
  int weight;
  int height;
  int baseExperience;

  Detail(
      {this.id,
      this.name,
      this.image,
      this.weight,
      this.height,
      this.baseExperience});
  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  PokeDetail pokemonDetail;

  @override
  void initState() {
    super.initState();
    _getPokemonDetail();
  }

  _getPokemonDetail() async {
    final PokeDetail pokemonResult =
        await pokeApi.getPokemonDetail(widget.name);
    setState(() {
      pokemonDetail = pokemonResult;
    });
  }

  List<Widget> _buildPokemonProfile() {
    return [
      Text("name    : " + pokemonDetail.name),
      Text("height   : " + pokemonDetail.height.toString()),
      Text("weight   : " + pokemonDetail.weight.toString()),
      Text("Exp   : " + pokemonDetail.baseExperience.toString())
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.name),
          backgroundColor: Colors.amberAccent,
        ),
        body: Container(
          decoration: new BoxDecoration(color: Colors.red),
          alignment: Alignment.center,
          width: double.infinity,
          child: InkWell(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Card(
                  child: Container(
                decoration: new BoxDecoration(color: Colors.amber),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Column(
                  children: <Widget>[
                    Hero(
                      tag: 'pokemon-${widget.id}',
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(widget.image),
                        width: 200,
                        height: 200,
                      ),
                    ),
                    if (pokemonDetail == null) CircularProgressIndicator(),
                    if (pokemonDetail != null) ..._buildPokemonProfile()
                  ],
                ),
              ))),
        ));
  }
}

class Pokemon {
  String name;
  String url;
  String id;

  Pokemon({this.name, this.url});

  Pokemon.fromJson(Map<String, dynamic> json) {
    final paths = json['url'].toString().split('/');

    name = json['name'];
    url = json['url'];

    id = paths[paths.length - 2].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    data['id'] = this.id;

    return data;
  }
}

class PokeDetail {
  List<Abilities> abilities;
  int baseExperience;
  List<Forms> forms;
  List<GameIndices> gameIndices;
  int height;
  List<HeldItems> heldItems;
  int id;
  bool isDefault;
  String locationAreaEncounters;
  List<Moves> moves;
  String name;
  int order;
  Species species;
  Sprites sprites;
  List<Stats> stats;
  List<Types> types;
  int weight;

  PokeDetail(
      {this.abilities,
      this.baseExperience,
      this.forms,
      this.gameIndices,
      this.height,
      this.heldItems,
      this.id,
      this.isDefault,
      this.locationAreaEncounters,
      this.moves,
      this.name,
      this.order,
      this.species,
      this.sprites,
      this.stats,
      this.types,
      this.weight});

  PokeDetail.fromJson(Map<String, dynamic> json) {
    if (json['abilities'] != null) {
      abilities = new List<Abilities>();
      json['abilities'].forEach((v) {
        abilities.add(new Abilities.fromJson(v));
      });
    }
    baseExperience = json['base_experience'];
    if (json['forms'] != null) {
      forms = new List<Forms>();
      json['forms'].forEach((v) {
        forms.add(new Forms.fromJson(v));
      });
    }
    if (json['game_indices'] != null) {
      gameIndices = new List<GameIndices>();
      json['game_indices'].forEach((v) {
        gameIndices.add(new GameIndices.fromJson(v));
      });
    }
    height = json['height'];
    if (json['held_items'] != null) {
      heldItems = new List<HeldItems>();
      json['held_items'].forEach((v) {
        heldItems.add(new HeldItems.fromJson(v));
      });
    }
    id = json['id'];
    isDefault = json['is_default'];
    locationAreaEncounters = json['location_area_encounters'];
    if (json['moves'] != null) {
      moves = new List<Moves>();
      json['moves'].forEach((v) {
        moves.add(new Moves.fromJson(v));
      });
    }
    name = json['name'];
    order = json['order'];
    species =
        json['species'] != null ? new Species.fromJson(json['species']) : null;
    sprites =
        json['sprites'] != null ? new Sprites.fromJson(json['sprites']) : null;
    if (json['stats'] != null) {
      stats = new List<Stats>();
      json['stats'].forEach((v) {
        stats.add(new Stats.fromJson(v));
      });
    }
    if (json['types'] != null) {
      types = new List<Types>();
      json['types'].forEach((v) {
        types.add(new Types.fromJson(v));
      });
    }
    weight = json['weight'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.abilities != null) {
      data['abilities'] = this.abilities.map((v) => v.toJson()).toList();
    }
    data['base_experience'] = this.baseExperience;
    if (this.forms != null) {
      data['forms'] = this.forms.map((v) => v.toJson()).toList();
    }
    if (this.gameIndices != null) {
      data['game_indices'] = this.gameIndices.map((v) => v.toJson()).toList();
    }
    data['height'] = this.height;
    if (this.heldItems != null) {
      data['held_items'] = this.heldItems.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['is_default'] = this.isDefault;
    data['location_area_encounters'] = this.locationAreaEncounters;
    if (this.moves != null) {
      data['moves'] = this.moves.map((v) => v.toJson()).toList();
    }
    data['name'] = this.name;
    data['order'] = this.order;
    if (this.species != null) {
      data['species'] = this.species.toJson();
    }
    if (this.sprites != null) {
      data['sprites'] = this.sprites.toJson();
    }
    if (this.stats != null) {
      data['stats'] = this.stats.map((v) => v.toJson()).toList();
    }
    if (this.types != null) {
      data['types'] = this.types.map((v) => v.toJson()).toList();
    }
    data['weight'] = this.weight;
    return data;
  }
}

class Abilities {
  Ability ability;
  bool isHidden;
  int slot;

  Abilities({this.ability, this.isHidden, this.slot});

  Abilities.fromJson(Map<String, dynamic> json) {
    ability =
        json['ability'] != null ? new Ability.fromJson(json['ability']) : null;
    isHidden = json['is_hidden'];
    slot = json['slot'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.ability != null) {
      data['ability'] = this.ability.toJson();
    }
    data['is_hidden'] = this.isHidden;
    data['slot'] = this.slot;
    return data;
  }
}

class Ability {
  String name;
  String url;

  Ability({this.name, this.url});

  Ability.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Forms {
  String name;
  String url;

  Forms({this.name, this.url});

  Forms.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class GameIndices {
  int gameIndex;
  Version version;

  GameIndices({this.gameIndex, this.version});

  GameIndices.fromJson(Map<String, dynamic> json) {
    gameIndex = json['game_index'];
    version =
        json['version'] != null ? new Version.fromJson(json['version']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['game_index'] = this.gameIndex;
    if (this.version != null) {
      data['version'] = this.version.toJson();
    }
    return data;
  }
}

class Version {
  String name;
  String url;

  Version({this.name, this.url});

  Version.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class HeldItems {
  Item item;
  List<VersionDetails> versionDetails;

  HeldItems({this.item, this.versionDetails});

  HeldItems.fromJson(Map<String, dynamic> json) {
    item = json['item'] != null ? new Item.fromJson(json['item']) : null;
    if (json['version_details'] != null) {
      versionDetails = new List<VersionDetails>();
      json['version_details'].forEach((v) {
        versionDetails.add(new VersionDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.item != null) {
      data['item'] = this.item.toJson();
    }
    if (this.versionDetails != null) {
      data['version_details'] =
          this.versionDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Item {
  String name;
  String url;

  Item({this.name, this.url});

  Item.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class VersionDetails {
  int rarity;
  Version version;

  VersionDetails({this.rarity, this.version});

  VersionDetails.fromJson(Map<String, dynamic> json) {
    rarity = json['rarity'];
    version =
        json['version'] != null ? new Version.fromJson(json['version']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['rarity'] = this.rarity;
    if (this.version != null) {
      data['version'] = this.version.toJson();
    }
    return data;
  }
}

class Moves {
  Move move;
  List<VersionGroupDetails> versionGroupDetails;

  Moves({this.move, this.versionGroupDetails});

  Moves.fromJson(Map<String, dynamic> json) {
    move = json['move'] != null ? new Move.fromJson(json['move']) : null;
    if (json['version_group_details'] != null) {
      versionGroupDetails = new List<VersionGroupDetails>();
      json['version_group_details'].forEach((v) {
        versionGroupDetails.add(new VersionGroupDetails.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.move != null) {
      data['move'] = this.move.toJson();
    }
    if (this.versionGroupDetails != null) {
      data['version_group_details'] =
          this.versionGroupDetails.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Move {
  String name;
  String url;

  Move({this.name, this.url});

  Move.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class VersionGroupDetails {
  int levelLearnedAt;
  MoveLearnMethod moveLearnMethod;
  VersionGroup versionGroup;

  VersionGroupDetails(
      {this.levelLearnedAt, this.moveLearnMethod, this.versionGroup});

  VersionGroupDetails.fromJson(Map<String, dynamic> json) {
    levelLearnedAt = json['level_learned_at'];
    moveLearnMethod = json['move_learn_method'] != null
        ? new MoveLearnMethod.fromJson(json['move_learn_method'])
        : null;
    versionGroup = json['version_group'] != null
        ? new VersionGroup.fromJson(json['version_group'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['level_learned_at'] = this.levelLearnedAt;
    if (this.moveLearnMethod != null) {
      data['move_learn_method'] = this.moveLearnMethod.toJson();
    }
    if (this.versionGroup != null) {
      data['version_group'] = this.versionGroup.toJson();
    }
    return data;
  }
}

class MoveLearnMethod {
  String name;
  String url;

  MoveLearnMethod({this.name, this.url});

  MoveLearnMethod.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class VersionGroup {
  String name;
  String url;

  VersionGroup({this.name, this.url});

  VersionGroup.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Species {
  String name;
  String url;

  Species({this.name, this.url});

  Species.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Sprites {
  String backDefault;
  String backFemale;
  String backShiny;
  String backShinyFemale;
  String frontDefault;
  String frontFemale;
  String frontShiny;
  String frontShinyFemale;

  Sprites(
      {this.backDefault,
      this.backFemale,
      this.backShiny,
      this.backShinyFemale,
      this.frontDefault,
      this.frontFemale,
      this.frontShiny,
      this.frontShinyFemale});

  Sprites.fromJson(Map<String, dynamic> json) {
    backDefault = json['back_default'];
    backFemale = json['back_female'];
    backShiny = json['back_shiny'];
    backShinyFemale = json['back_shiny_female'];
    frontDefault = json['front_default'];
    frontFemale = json['front_female'];
    frontShiny = json['front_shiny'];
    frontShinyFemale = json['front_shiny_female'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['back_default'] = this.backDefault;
    data['back_female'] = this.backFemale;
    data['back_shiny'] = this.backShiny;
    data['back_shiny_female'] = this.backShinyFemale;
    data['front_default'] = this.frontDefault;
    data['front_female'] = this.frontFemale;
    data['front_shiny'] = this.frontShiny;
    data['front_shiny_female'] = this.frontShinyFemale;
    return data;
  }
}

class Stats {
  int baseStat;
  int effort;
  Stat stat;

  Stats({this.baseStat, this.effort, this.stat});

  Stats.fromJson(Map<String, dynamic> json) {
    baseStat = json['base_stat'];
    effort = json['effort'];
    stat = json['stat'] != null ? new Stat.fromJson(json['stat']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['base_stat'] = this.baseStat;
    data['effort'] = this.effort;
    if (this.stat != null) {
      data['stat'] = this.stat.toJson();
    }
    return data;
  }
}

class Stat {
  String name;
  String url;

  Stat({this.name, this.url});

  Stat.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

class Types {
  int slot;
  Type type;

  Types({this.slot, this.type});

  Types.fromJson(Map<String, dynamic> json) {
    slot = json['slot'];
    type = json['type'] != null ? new Type.fromJson(json['type']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['slot'] = this.slot;
    if (this.type != null) {
      data['type'] = this.type.toJson();
    }
    return data;
  }
}

class Type {
  String name;
  String url;

  Type({this.name, this.url});

  Type.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['url'] = this.url;
    return data;
  }
}

//Main
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MainScreen();
  }
}

//MainScreen
class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Pokedex',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: Home(),
        onGenerateRoute: (RouteSettings settings) {
          Map params = settings.arguments;
          switch (settings.name) {
            case '/home':
              return MaterialPageRoute(builder: (context) => Home());
              break;
            case '/detail':
              return MaterialPageRoute(
                  builder: (context) => Detail(
                      id: params['id'],
                      name: params['name'],
                      image: params['image']));
              break;
            default:
              return MaterialPageRoute(builder: (context) => Home());
          }
        });
  }
}

//home

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  KtList<Pokemon> _pokemonList = emptyList();
  bool _isLoading = false;
  final ScrollController _scrollController =
      ScrollController(debugLabel: 'pokemonSc');

  @override
  void initState() {
    super.initState();
    _fetchPokemonList();

    _scrollController.addListener(() {
      if (!_isLoading && _scrollController.position.extentAfter == 0.0) {
        _fetchPokemonList();
      }
    });
  }

  _fetchPokemonList() async {
    setState(() {
      _isLoading = true;
    });
    final pokemonList = await pokeApi.getPokemonList(_pokemonList.size);
    setState(() {
      _pokemonList = _pokemonList.plus(pokemonList);
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: new Text("List Of Pokemons"),
              backgroundColor: Colors.amberAccent,
            ),
            body: CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverGrid(
                  delegate: SliverChildBuilderDelegate((ctx, index) {
                    var item = _pokemonList[index];

                    return PokemonCard(
                        id: item.id,
                        image: getPokemonImage(item.id),
                        color: Colors.amber,
                        key: ValueKey(item.id),
                        onTap: () {
                          Navigator.pushNamed(context, '/detail', arguments: {
                            'id': item.id,
                            'name': item.name,
                            'image': getPokemonImage(item.id)
                          });
                        });
                  }, childCount: 151),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3),
                ),
                SliverToBoxAdapter(
                    child: _isLoading
                        ? Container(
                            alignment: Alignment.center,
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: CircularProgressIndicator(),
                          )
                        : SizedBox())
              ],
            )));
  }
}

//widgets

class PokemonCard extends StatelessWidget {
  String id;
  String image;
  Color color;
  Function onTap;
  ValueKey key;

  PokemonCard(
      {@required this.id,
      @required this.image,
      @required this.color,
      @required this.onTap,
      this.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
          onTap: onTap,
          child: Container(
              decoration: BoxDecoration(
                color: Colors.amber,
                border: Border.all(width: 5.0, color: Colors.yellowAccent),
                borderRadius: BorderRadius.all(Radius.circular(5.0)),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: color,
                    child: Hero(
                      tag: 'pokemon-$id',
                      child: Image(
                        fit: BoxFit.cover,
                        image: NetworkImage(image),
                      ),
                    ),
                  ),
                  Text("pokemon",
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Positioned(
                    top: 0.0,
                    right: 0.0,
                    child: Container(
                      height: 30.0,
                      width: 40.0,
                      color: Colors.white,
                      child: Text('#$id'),
                      alignment: Alignment.center,
                    ),
                  )
                ],
              ))),
    );
  }
}
