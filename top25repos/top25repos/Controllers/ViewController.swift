//
//  ViewController.swift
//  top25repos
//
//  Created by Sergey Vinogradov on 22.04.2019.
//  Copyright © 2019 RedBite. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private var tableView: UITableView!

    private let urlPrefix = "https://api.github.com"
    private var repos: [Repository] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: RepoTableViewCell.identifier, bundle: nil), forCellReuseIdentifier: RepoTableViewCell.identifier)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchReposFor("swift") {[unowned self] (repos) in
            self.repos = repos
            self.tableView.reloadData()
        }
    }

    // MARK: - Private
    
    private func searchReposFor(_ language: String, completion: @escaping (_ response: [Repository]) -> Void) {
        guard let url = URL(string: urlPrefix+"/search/repositories?q=tetris+language:\(language)&sort=stars&order=desc") else { return }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            var result:[Repository] = []
            if error != nil {
                print("Search error \(String(describing: error?.localizedDescription))")
                DispatchQueue.main.async {
                    completion(result)
                }
                return
            }
            
            guard let data = data else { return }
            let decoder = JSONDecoder()
            do {
                let responseObject = try decoder.decode(RootClass.self, from: data)
                
                if let itemsList = responseObject.items {
                    var limit = 25
                    for item in itemsList {
                        limit -= 1
                        if limit < 0 {
                            break
                        }
                        
                        var username = ""
                        var avatarUrl = ""
                        var gravatar = ""
                        
                        if let owner = item.owner {
                            if let login = owner.login {
                                username = login
                            }
                            if let imageUrl = owner.avatarUrl {
                                avatarUrl = imageUrl
                            }
                            if let gravatarId = owner.gravatarId {
                                gravatar = gravatarId
                            }
                        }
                        
                        if username.isEmpty, let repoTitle = item.fullName { // then try to get repo's name
                            if let index = repoTitle.firstIndex(of: "/") {
                                username = String(repoTitle.prefix(upTo: index))
                            } else {
                                username = repoTitle
                            }
                        }
                        
                        let repo = Repository.init(avatarUrl: avatarUrl, gravatarId: gravatar, username: username, commitCount: 0)
                        result.append(repo)
                    }
                }
                
                print("Search complete")
                DispatchQueue.main.async {
                    completion(result)
                }
            } catch {
                print("Search fail serialization \(error)")
                DispatchQueue.main.async {
                    completion(result)
                }
            }
        }.resume()
    }
}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, !text.isEmpty else { return false }
        
        repos = []
        tableView.reloadData()
        textField.resignFirstResponder()
        
        searchReposFor(text) { (repos) in
            // FIXME: CopyPaste
            self.repos = repos
            self.tableView.reloadData()
        }
        
        return true
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return repos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.identifier, for: indexPath) as? RepoTableViewCell else { return UITableViewCell() }
        cell.repository = repos[indexPath.row]
        return cell
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
}
