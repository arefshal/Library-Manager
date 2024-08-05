//
//  ViewController.swift
//  Library Manager
//
//  Created by Aref on 8/4/24.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIPickerViewDelegate, UIPickerViewDataSource, UISearchBarDelegate, UITextFieldDelegate {
    // MARK: - Properties

    let categories = ["Scientific", "Novel", "Historical", "Others"]
    var selectedCategory: String = ""
    var books: [Book] = []
    var filteredBooks: [Book] = []
    var selectedFilterCategory: String = "All"
    var searchText: String = ""

    // MARK: - UI Elements

    var searchBar: UISearchBar!
    var tableView: UITableView!
    var titleTextField: UITextField!
    var authorTextField: UITextField!
    var categoryButton: UIButton!
    var addButton: UIButton!
    var pickerView: UIPickerView!
    var filterButton: UIButton!
    var filterPickerView: UIPickerView!

    // MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        setupKeyboardObservers()
        addTapGestureToDismissKeyboard()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // MARK: - UI Setup

    /// Setup the user interface elements
    private func setupUI() {
        
        setupTableView()
        setupSearchBar()
        setupInputFields()
        setupCategoryButton()
        setupAddButton()
        setupFilterButton()
        setupPickerView()
        setupFilterPickerView()
        setupConstraints()
    }

    private func setupSearchBar() {
        searchBar = UISearchBar()
        searchBar.placeholder = "Search by author"
        searchBar.delegate = self
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(searchBar)
    }

    private func setupTableView() {
        
        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BookCell")
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        view.addSubview(tableView)
    }

    /// Setup the input fields
    private func setupInputFields() {
        
        titleTextField = UITextField()
        titleTextField.placeholder = "Title"
        titleTextField.borderStyle = .roundedRect
        titleTextField.returnKeyType = .next
        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        titleTextField.delegate = self
        view.addSubview(titleTextField)

        authorTextField = UITextField()
        authorTextField.placeholder = "Author"
        authorTextField.borderStyle = .roundedRect
        authorTextField.returnKeyType = .done
        authorTextField.translatesAutoresizingMaskIntoConstraints = false
        authorTextField.delegate = self
        view.addSubview(authorTextField)
    }

    /// Setup category button
    private func setupCategoryButton() {
        
        categoryButton = UIButton(type: .system)
        categoryButton.setTitle("Select Category", for: .normal)
        categoryButton.addTarget(self, action: #selector(showCategoryPicker), for: .touchUpInside)
        categoryButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(categoryButton)
    }

    /// Setup add button
    private func setupAddButton() {
        
        addButton = UIButton(type: .system)
        addButton.setTitle("Add Book", for: .normal)
        addButton.addTarget(self, action: #selector(addBook), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(addButton)
    }

    /// Setup filter button
    private func setupFilterButton() {
        
        filterButton = UIButton(type: .system)
        filterButton.setTitle("Filter Books", for: .normal)
        filterButton.addTarget(self, action: #selector(showFilterPicker), for: .touchUpInside)
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterButton)
    }

    /// Setup picker view
    private func setupPickerView() {
        
        pickerView = UIPickerView()
        pickerView.backgroundColor = .systemBlue
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.isHidden = true
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pickerView)
    }

    /// Setup filter picker view
    private func setupFilterPickerView() {
        
        filterPickerView = UIPickerView()
        filterPickerView.backgroundColor = .systemGreen
        filterPickerView.delegate = self
        filterPickerView.dataSource = self
        filterPickerView.isHidden = true
        filterPickerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(filterPickerView)
    }

    /// Setup all constraints
    private func setupConstraints() {
        
        NSLayoutConstraint.activate([
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchBar.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: view.trailingAnchor),

            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: titleTextField.topAnchor, constant: -20),

            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            titleTextField.bottomAnchor.constraint(equalTo: authorTextField.topAnchor, constant: -10),

            authorTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            authorTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            authorTextField.bottomAnchor.constraint(equalTo: categoryButton.topAnchor, constant: -10),

            categoryButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            categoryButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            categoryButton.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -10),

            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: filterButton.topAnchor, constant: -10),

            filterButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            filterButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            filterButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),

            pickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            pickerView.heightAnchor.constraint(equalToConstant: 200),

            filterPickerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            filterPickerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            filterPickerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            filterPickerView.heightAnchor.constraint(equalToConstant: 200),
        ])
    }

    // MARK: - Actions

    @objc func showCategoryPicker() {
        
        pickerView.isHidden = false
    }

    @objc func showFilterPicker() {
        
        filterPickerView.isHidden = false
    }

    @objc func addBook() {
        
        guard let title = titleTextField.text, !title.isEmpty,
              let author = authorTextField.text, !author.isEmpty,
              !selectedCategory.isEmpty else {
            let alert = UIAlertController(title: "Error", message: "Please fill all fields", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            
            return
        }

        let newBook = Book(title: title, author: author, category: selectedCategory)
        books.append(newBook)
        applyFilter()

        // Clear fields after adding
        titleTextField.text = ""
        authorTextField.text = ""
        categoryButton.setTitle("Select Category", for: .normal)
        selectedCategory = ""
    }

    /// Apply filter based on the selected category
    func applyFilter() {
        
        filteredBooks = books.filter { book in
            let categoryMatch = selectedFilterCategory == "All" || book.category == selectedFilterCategory
            let authorMatch = searchText.isEmpty || book.author.lowercased().contains(searchText.lowercased())
            
            return categoryMatch && authorMatch
        }
        tableView.reloadData()
    }

    // MARK: - UITableViewDataSource
    // This section of code was implemented using a tutorial from Medium
    // Source: https://paigeshin1991.medium.com/uikit-tableview-implement-add-edit-move-features-in-the-easiest-possible-way-400b3f278ddd

    /// Handle swipe-to-delete action
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return filteredBooks.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath)
        let book = filteredBooks[indexPath.row]

        cell.textLabel?.text = "📚 \(book.title) by \(book.author)"

        return cell
    }

    // MARK: - UITableViewDelegate
    // Source: https://paigeshin1991.medium.com/uikit-tableview-implement-add-edit-move-features-in-the-easiest-possible-way-400b3f278ddd

    /// Handle swipe-to-delete action
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Remove the book from the data source
            let bookToRemove = filteredBooks[indexPath.row]
            if let index = books.firstIndex(where: { $0.title == bookToRemove.title && $0.author == bookToRemove.author && $0.category == bookToRemove.category }) {
                
                books.remove(at: index)
            }
            applyFilter()
        }
    }

    /// Handle row selection
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedBook = filteredBooks[indexPath.row]
        showBookDetails(book: selectedBook)
    }

    /// Show book details in an alert
    func showBookDetails(book: Book) {
        
        let alert = UIAlertController(title: "Book Details", message: nil, preferredStyle: .alert)

        let detailsMessage = """
        Title: \(book.title)
        Author: \(book.author)
        Category: \(book.category)
        """

        alert.message = detailsMessage

        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        present(alert, animated: true, completion: nil)
    }

    // MARK: - UIPickerViewDataSource

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == self.pickerView {
            return categories.count
        } else {
            return categories.count + 1
        }
    }

    // MARK: - UIPickerViewDelegate

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        if pickerView == self.pickerView {
            return categories[row]
        } else {
            return row == 0 ? "All" : categories[row - 1]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView == self.pickerView {
            selectedCategory = categories[row]
            categoryButton.setTitle(selectedCategory, for: .normal)
            pickerView.isHidden = true
        } else {
            selectedFilterCategory = row == 0 ? "All" : categories[row - 1]
            filterButton.setTitle("Filter: \(selectedFilterCategory)", for: .normal)
            filterPickerView.isHidden = true
            applyFilter()
        }
    }

    // MARK: - UISearchBarDelegate

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        applyFilter()
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }

    // MARK: - Keyboard Handling
    // This section of code was generated with the assistance of GPT
    // Purpose: Handle keyboard appearance and disappearance to avoid UI issues
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc private func keyboardWillShow(notification: Notification) {
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let bottomSpace = view.frame.height - (filterButton.frame.origin.y + filterButton.frame.height)
            view.frame.origin.y = bottomSpace - keyboardHeight
        }
    }

    @objc private func keyboardWillHide(notification: Notification) {
        view.frame.origin.y = 0
    }

    private func addTapGestureToDismissKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGesture.cancelsTouchesInView = false
        view.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }

    // MARK: - UITextFieldDelegate

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == titleTextField {
            authorTextField.becomeFirstResponder()
        } else if textField == authorTextField {
            textField.resignFirstResponder()
        }
        return true
    }
}

#Preview {
    ViewController()
}

