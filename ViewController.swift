//
//  ViewController.swift
//  PokemonGO
//
//  Created by Macbook on 11/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapa: MKMapView!
    var gerenciadorLocalizacao = CLLocationManager()
    var contador = 0
    var coreDataPokemon:CoreDataPokemon!
    var pokemons:[Pokemon] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapa.delegate = self
        gerenciadorLocalizacao.delegate = self
        gerenciadorLocalizacao.requestWhenInUseAuthorization()
        gerenciadorLocalizacao.startUpdatingLocation()
        
        coreDataPokemon = CoreDataPokemon()
        pokemons = coreDataPokemon.recuperarPokemons()
        
        Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { (timer) in
            
            if let coordenadas = self.gerenciadorLocalizacao.location?.coordinate{
            
                let totalPokemons = UInt32(self.pokemons.count)
                let indicePokemonAleatorio = arc4random_uniform(totalPokemons)
                let pokemon = self.pokemons[Int(indicePokemonAleatorio)]
                
                
                let anotation = PokemonAnotacao(coordenadas: coordenadas, pokemon: pokemon)
                let latAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                let longAleatoria = (Double(arc4random_uniform(500)) - 250) / 100000.0
                
                anotation.coordinate.latitude += latAleatoria
                anotation.coordinate.longitude += longAleatoria
                self.mapa.addAnnotation(anotation)
            }
        }
        
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let anotation = view.annotation
        mapView.deselectAnnotation(anotation, animated: true)
         let pokemon = (anotation as! PokemonAnotacao).pokemon
        
        if anotation is MKUserLocation{
            return
        }
        if let coordAnotacao = anotation?.coordinate{
            let regiao = MKCoordinateRegionMakeWithDistance(coordAnotacao, 200, 200)
            mapa.setRegion(regiao, animated: true)
        }
        
        Timer.scheduledTimer(withTimeInterval: 1, repeats: false) { (timer) in
            if let coord = self.gerenciadorLocalizacao.location?.coordinate
            {
                let alertCaptura = UIAlertController(title: "Parabens",  message: "Você capturou o pokémon: \(pokemon.nome ?? "")", preferredStyle: .alert)
                
                let alertNaoCaptura = UIAlertController(title: "Você não pode Capturar",  message: "Você precisa se aproximar mais para caturar o pokémon: \(pokemon.nome ?? "")", preferredStyle: .alert)
                
                let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
                
                alertNaoCaptura.addAction(ok)
                alertCaptura.addAction(ok)
                
                
                if MKMapRectContainsPoint(self.mapa.visibleMapRect, MKMapPointForCoordinate(coord)){
                    
                    self.coreDataPokemon.salvarPokemon(pokemon: pokemon)
                    self.mapa.removeAnnotation(anotation!)
                    self.present(alertCaptura, animated: true, completion: nil)
                }
                else{
                    self.present(alertNaoCaptura, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let anotacaoView = MKAnnotationView(annotation: annotation, reuseIdentifier: nil)
        
        if annotation is MKUserLocation{
            anotacaoView.image = #imageLiteral(resourceName: "player")
        }
        else{
            let pokemon = (annotation as! PokemonAnotacao).pokemon
            anotacaoView.image = UIImage(named: pokemon.nomeImagem!)
            
        }
        var frame = anotacaoView.frame
        frame.size.height = 40
        frame.size.width = 40
        
        anotacaoView.frame = frame
        
        return anotacaoView
    }

    @IBAction func abrirPokedex(_ sender: Any) {
    }
    @IBAction func centralizarJogador(_ sender: Any) {
       self.centralizar()
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    func centralizar()
        {
            if let coordenadas = gerenciadorLocalizacao.location?.coordinate{
                
                let regiao = MKCoordinateRegionMakeWithDistance(coordenadas, 200, 200)
                
                self.mapa.setRegion(regiao, animated: true)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status != .authorizedWhenInUse && status != .notDetermined
        {
            let alert = UIAlertController(title: "Permissão de Localização", message: "Necsessario permissão de acesso a sua localizacao pra caçar pokeomns! por favor habilite!", preferredStyle: .alert)
            
            let acaoConfiguracao = UIAlertAction(title: "Abrir configuração", style: .default, handler: { (alertConfiguracoes) in
                if let configuracoes = NSURL(string: UIApplicationOpenSettingsURLString){
                    UIApplication.shared.open(configuracoes as URL)
                }
            })
            
            let acaoCancelar = UIAlertAction(title: "Cancelar", style: .default, handler: nil)
            
            alert.addAction(acaoConfiguracao)
            alert.addAction(acaoCancelar)
            
            present(alert, animated: true, completion: nil)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if contador <= 3 {
        self.centralizar()
        
        print("Executou")
            contador += 1
        }
        else{
            gerenciadorLocalizacao.stopUpdatingLocation()
            print("Parou de executar")
        }
    }


}

