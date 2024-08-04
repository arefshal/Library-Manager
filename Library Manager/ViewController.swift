//
//  ViewController.swift
//  Library Manager
//
//  Created by Aref on 8/4/24.
//

import UIKit

class ViewController: UIViewController {
    // MARK: - Properties

    let categories = ["Scientific", "Novel", "Historical", "Others"]
    var selectedCategory: String = ""
    var books: [Book] = []
    var filteredBooks: [Book] = []
    var selectedFilterCategory: String = "All"

    // MARK: - UI Elements

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
    }
    // MARK: - UI Setup

    /// Setup the user interface elements
    private func setupUI() {
        setupTableView()
        setupInputFields()
        setupCategoryButton()
        setupAddButton()
        setupFilterButton()
        setupPickerView()
        setupFilterPickerView()
        setupConstraints()
    }
    
}

