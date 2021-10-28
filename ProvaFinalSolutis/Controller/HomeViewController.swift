
//  HomeViewController.swift
//  ProvaFinalSolutis
//
//  Created by Virtual Machine on 14/10/21.
//

import UIKit

class HomeViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var puxarDados: ModelUser?
    var puxarDadosExtratos: [ModelExtrato?] = []
    
    
    @IBOutlet weak var homeviewcolor: UIView!
    @IBOutlet weak var nomeUsuarioTextView: UITextView!
    @IBOutlet weak var cpfUsuarioTextView: UITextView!
    @IBOutlet weak var saldoUsuarioTextView: UITextView!
    @IBOutlet weak var Tabela: UITableView!
    
    let alamofire = ApiRequest()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Tabela .dataSource = self
        Tabela .delegate = self
        
        
        
        nomeUsuarioTextView.text = puxarDados?.nome
        cpfUsuarioTextView.text = puxarDados?.cpf
        saldoUsuarioTextView.text = pontoVirgula(Pontovirgula: puxarDados?.saldo)
        cpfUsuarioTextView.text = formatCPF(puxarDados?.cpf)
        
        getStatement(token: puxarDados!.token)
        
        setGradient()
        
        
    }
    
    func getStatement(token: String) {
        alamofire.getStatement(token: token) { response in
            switch response {
            case.success(let extrato):
                DispatchQueue.main.async {
                    self.puxarDadosExtratos = extrato
                    self.Tabela.reloadData()
                    print(self.puxarDadosExtratos)
                }
                
            case .failure(let error):
                print(error)
                
                
            }
            
            
        }
    }
 
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.puxarDadosExtratos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = Bundle.main.loadNibNamed("CellDados", owner: self, options: nil)?.first  as! CellDados
        let extrato = puxarDadosExtratos[indexPath.row]
        cell.lblData.text = Utils().formatarData(data: extrato!.data)
        cell.lblConta.text = extrato?.descricao
        if (extrato!.valor < 0) {
            cell.Lblvalor.textColor = UIColor.red
            cell.lblStatus.text = "Pagamento"
            let valor = String (format: "R$ %.2f", extrato!.valor).replacingOccurrences(of: "-", with: "")
            
            cell.Lblvalor.text = String(format: "- %@", valor).replacingOccurrences(of: ".", with: ",")
        }else{
            cell.Lblvalor.textColor = UIColor.green
            cell.lblStatus.text = "Recebimento"
            cell.Lblvalor.text = String (format: "R$ %.2f", extrato!.valor).replacingOccurrences(of: ".", with: ",")
        }
        
   
        return cell
    }
    
    
    
    
    func pontoVirgula(Pontovirgula: Double?) -> String {
        if let value = Pontovirgula {
            return String(format: "R$ %.2f", value).replacingOccurrences(of: ".", with: ",")
        }
        return ""
    }
    
   
    
    @IBAction func logouButton(_ sender: UIButton) {
     
        let alert = UIAlertController(title: "Aviso", message: "Deseja mesmo sair ?", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Sair", style: .destructive, handler: { UIAlertAction in
            self.performSegue(withIdentifier: "logoutSegue", sender: self)
        }))
   
            
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
        
    }
        
    
    func setGradient(){
        
        let view = self.homeviewcolor
        
        let gradient = CAGradientLayer()
        
        
        
        gradient.frame = view!.bounds
        
        gradient.colors = [UIColor(red: 177/256, green: 199/256, blue: 228/256, alpha: 1.0).cgColor, UIColor(red: 0/256, green: 116/256, blue: 178/256, alpha: 1.0).cgColor]
        
        
        
        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
        
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        
        view!.layer.insertSublayer(gradient, at: 0)
    }
    
    
    func formatCPF(_ textoPuro: String?) -> String? {
        
        var textoFormatado = ""
        var lastPos = 0
        
        if (textoPuro?.count ?? 0) > 3 {
            textoFormatado += (textoPuro as NSString?)?.substring(with: NSRange(location: 0, length: 3)) ?? ""
            textoFormatado += "."
            lastPos = 3
        }
        if (textoPuro?.count ?? 0) > 6 {
            textoFormatado += (textoPuro as NSString?)?.substring(with: NSRange(location: 3, length: 3)) ?? ""
            textoFormatado += "."
            lastPos = 6
        }
        if (textoPuro?.count ?? 0) > 9 {
            textoFormatado += (textoPuro as NSString?)?.substring(with: NSRange(location: 6, length: 3)) ?? ""
            textoFormatado += "-"
            lastPos = 9
        }
        textoFormatado += (textoPuro as NSString?)?.substring(with: NSRange(location: lastPos, length: (textoPuro?.count ?? 0) - lastPos)) ?? ""
        
        return textoFormatado.description
    }
    
    
}



