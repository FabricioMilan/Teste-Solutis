//
//  ApiRequest.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 18/10/21.
//

import Foundation
import Alamofire

enum APIErros : Error {
    case custom(menssage: String)
}
typealias loginHandler = (Swift.Result < ModelUser, APIErros>) -> Void
typealias statementHandler = (Swift.Result < [ModelExtrato], APIErros>) -> Void


class ApiRequest{
    static let shareInstance = ApiRequest()
    
    func doLogin (login: ModelLogin, completionHandler: @escaping (loginHandler)) {
        let hearders: HTTPHeaders = [
            .contentType("application/json")]
        
        AF.request(LoginUrl, method: .post, parameters: login, encoder: JSONParameterEncoder.default, headers: hearders).response { response in
            //            debugPrint(response)
            switch response.result {
            case.success(let data):
                do{
                    let Json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200{
                        let resposta = Json as! NSDictionary
                        var saldoformatado = String(format: "%.2f", resposta["saldo"] as! Double)
                        let usuario = ModelUser(nome: (resposta["nome"]as! String), cpf: (resposta["cpf"]as! String), saldo: (resposta["saldo"]as! Double), token: (resposta["token"]as! String))
                        
                        
                        completionHandler(.success(usuario))
                        
                        
                    }else{
                        completionHandler(.failure(.custom(menssage: "Credenciais invalidas")))
                        
                    }
                }catch{
                    print(error.localizedDescription)
                }
            case .failure(let erros) :
                print(erros.localizedDescription)
            }
        }
    }
    
    
    
    func getStatement(token: String, completionHandler: @escaping (statementHandler)) {
        let headers = ["token": token ] as HTTPHeaders
        
        AF.request(ExtratoUrl, method: .get, headers: headers).response{ response in
            switch response.result{
            case.success(let data):
                do{
                    let Json = try JSONSerialization.jsonObject(with: data!, options: [])
                    if response.response?.statusCode == 200{
                        let resposta = Json as! [NSDictionary]
//                        print(resposta)
                        var arrayExtrato: [ModelExtrato] = []
                        
                        for respostaExtrato in resposta {
                            let extrato = ModelExtrato(data: (respostaExtrato["data"]as! String), descricao: (respostaExtrato["descricao"]as! String), valor: (respostaExtrato["valor"]as! Double))
                            arrayExtrato.append(extrato)
                        }
                        
                        completionHandler(.success(arrayExtrato))
                    }
                }catch{
                    print("a")
                }
                print(token)
            case .failure(let erros):
                print("falha na conexao")
            }
        }
    }
}

