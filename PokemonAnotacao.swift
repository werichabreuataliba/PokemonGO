//
//  PokemonAnotacao.swift
//  PokemonGO
//
//  Created by Macbook on 12/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import MapKit

class PokemonAnotacao: NSObject, MKAnnotation
{
  var coordinate: CLLocationCoordinate2D
    var pokemon: Pokemon
    init(coordenadas:CLLocationCoordinate2D, pokemon:Pokemon) {
        self.coordinate = coordenadas
        self.pokemon = pokemon
    }
}
