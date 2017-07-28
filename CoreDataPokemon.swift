//
//  CoreDataPokemon.swift
//  PokemonGO
//
//  Created by Macbook on 11/03/17.
//  Copyright © 2017 Werich. All rights reserved.
//

import UIKit
import CoreData

class CoreDataPokemon
{
    //recupera Contexto
    func getContext() -> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as? AppDelegate
        let context = appDelegate?.persistentContainer.viewContext
        return context!
    }
    
    func recuperarPokemon(capturado:Bool)->[Pokemon]
    {
        let context = getContext()
        let requisicao = Pokemon.fetchRequest() as NSFetchRequest<Pokemon>
    
        requisicao.predicate = NSPredicate(format: "capturado = %@", capturado as CVarArg)
        
        do{
            
            let pokemons = try context.fetch(requisicao)
            return pokemons
            
        }catch
        {
            
        }
        return []
    }
    
    func salvarPokemon(pokemon: Pokemon)
    {
        let context = getContext()
        pokemon.capturado = true
        
        do{
            try context.save()
        }
        catch let erro as NSError
        {
            print("Erro ao salvar pokemon : \(erro.description)")
        }
        
    }
    
    //adicionar todos os pokemons
    func adicionarTodosPokemons()
    {
         let context = self.getContext()
        
        self.criarPokemon(nome: "Mew", nomeImagem: "mew", capturado: false)
        self.criarPokemon(nome: "Caterpie", nomeImagem: "caterpie", capturado: false)
        self.criarPokemon(nome: "Dratini", nomeImagem: "dratini", capturado: false)
        self.criarPokemon(nome: "Eeve", nomeImagem: "eeve", capturado: false)
        self.criarPokemon(nome: "Bullbassaur", nomeImagem: "bullbassaur", capturado: false)
        self.criarPokemon(nome: "Jigglypuff", nomeImagem: "jigglypuff", capturado: false)
        self.criarPokemon(nome: "Mankey", nomeImagem: "mankey", capturado: false)
        self.criarPokemon(nome: "Meowth", nomeImagem: "meowth", capturado: false)
        self.criarPokemon(nome: "Pikachu", nomeImagem: "pikachu-2", capturado: false)
        self.criarPokemon(nome: "Snorlax", nomeImagem: "snorlax", capturado: false)
        self.criarPokemon(nome: "Venonat", nomeImagem: "venonat", capturado: false)
        self.criarPokemon(nome: "Weedle", nomeImagem: "weedle", capturado: false)
        self.criarPokemon(nome: "Zubat", nomeImagem: "zubat", capturado: false)
        
        do{
            try context.save()
            
        }catch let erro as NSError
        {
            print("Erro as salvar: \(erro.description)")
        }
    }
    
    
    func recuperarPokemons()-> [Pokemon]{
        let context = getContext()
        
        do{
            
            let pokemons = try context.fetch(Pokemon.fetchRequest()) as! [Pokemon]
            
            if pokemons.count == 0
            {
                adicionarTodosPokemons()
                return self.recuperarPokemons()
            }
            
            
            return pokemons
            
        }catch let erro as NSError
        {
            print("Erro: \(erro.description)")
        }
        
        return []
    }
    
    func criarPokemon(nome: String, nomeImagem: String, capturado: Bool)
    {
        let context = self.getContext()
        let pokemon = Pokemon(context: context)
        pokemon.nome = nome
        pokemon.nomeImagem = nomeImagem
        pokemon.capturado = capturado
        
    }
}
