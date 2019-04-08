//
//  EventController.swift
//  iTRaveler
//
//  Created by Erandra Jayasundara on 1/27/19.
//  Copyright © 2019 Erandra Jayasundara. All rights reserved.
//

import UIKit
import GooglePlaces
class EventController: UICollectionViewController,UICollectionViewDelegateFlowLayout,UITextFieldDelegate {
    let newEventView:UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    let editEventImage:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(r:77,g:175,b:81)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("Edit", for: .normal)
        btn.addTarget(self, action: #selector(handleeditEventImage), for: .touchUpInside)
        btn.alpha = 0.50
        return btn
    }()
  
    let eventImage:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile")
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    let eventNameTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="Event Name"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let eventDateTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="Select Date and Time"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let eventDescTextField:UITextField = {
        let tf=UITextField()
        tf.placeholder="Descripton abount Event"
        tf.textColor=UIColor(r:77,g:175,b:81)
        tf.layer.borderColor = UIColor(r:77,g:175,b:81).cgColor
        tf.layer.borderWidth = 1.0
        tf.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0)
        return tf
    }()
    let locationSelectButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Select Location", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(selectLocation), for: .touchUpInside)
        return button
    }()
    let addEventButton:UIButton={
        let button=UIButton(type: .system)
        button.backgroundColor=UIColor(r:77,g:175,b:81)
        button.setTitle("Add Event", for: .normal)
        button.layer.cornerRadius=5
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.masksToBounds=true
        button.titleLabel?.font=UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints=false
        button.addTarget(self, action: #selector(addEvent), for: .touchUpInside)
        return button
    }()
    @objc func addEvent(){
        updateDBWithEvent()
    }
    @objc func selectLocation(){
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    @objc func showEventView(){
        if newEventView.isDescendant(of: view) {
            newEventView.removeFromSuperview()
            eventDescTextField.text = ""
            eventDateTextField.text = ""
            eventNameTextField.text = ""
            eventImage.image = UIImage(named: "profile")
        } else {
            populateUIEventView()
        }
       
    }
    @objc func datePickerFunc(sender:UIDatePicker) {
        let dateFormet = DateFormatter()
        dateFormet.dateStyle = DateFormatter.Style.medium
        dateFormet.timeStyle = DateFormatter.Style.medium
        eventDateTextField.text = dateFormet.string(from: (sender.date))
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       
        let dataPickerView = UIDatePicker()
        dataPickerView.datePickerMode = UIDatePickerMode.dateAndTime
        textField.inputView = dataPickerView
        dataPickerView.addTarget(self, action:   #selector(datePickerFunc), for: UIControlEvents.valueChanged)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    func populateUIEventView(){
        view.addSubview(newEventView)
        newEventView.setAnchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: view.frame.height)
        newEventView.addSubview(eventImage)
        eventImage.setAnchor(top: newEventView.topAnchor, left: newEventView.leftAnchor, bottom: nil, right: nil, paddingTop: 10, paddingLeft: (view.frame.width-150)/2, paddingBottom: 0, paddingRight: 0, width: 150, height: 150)
        eventImage.addSubview(editEventImage)
        editEventImage.setAnchor(top: nil, left: eventImage.leftAnchor, bottom: eventImage.bottomAnchor, right: eventImage.rightAnchor
            , paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 30)
        newEventView.addSubview(eventNameTextField)
        eventNameTextField.setAnchor(top: eventImage.bottomAnchor, left: newEventView.leftAnchor, bottom: nil, right: newEventView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        newEventView.addSubview(eventDateTextField)
        eventDateTextField.setAnchor(top: eventNameTextField.bottomAnchor, left: newEventView.leftAnchor, bottom: nil, right: newEventView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        eventDateTextField.delegate = self
        newEventView.addSubview(locationSelectButton)
        locationSelectButton.setAnchor(top: eventDateTextField.bottomAnchor, left: newEventView.leftAnchor, bottom: nil, right: newEventView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
        newEventView.addSubview(eventDescTextField)
        eventDescTextField.setAnchor(top: locationSelectButton.bottomAnchor, left: newEventView.leftAnchor, bottom: nil, right: newEventView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 40)
        newEventView.addSubview(addEventButton)
        addEventButton.setAnchor(top: eventDescTextField.bottomAnchor, left: newEventView.leftAnchor, bottom: nil, right: newEventView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 40)
       
    }
    var location = ""
    var latitude = ""
    var longitude = ""
    var events = [Event]()
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let imag = UIImage(named: "share")
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: imag, style: .plain, target: self, action:  #selector(showEventView))
        updateEvents()
        collectionView?.backgroundColor = UIColor(white: 0.95, alpha: 1)
        collectionView?.alwaysBounceVertical = true
        collectionView?.register(EventCell.self, forCellWithReuseIdentifier: cellId)
        
    }
    let cellId = "cellId"
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width:view.frame.width,height:76)
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let eventCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! EventCell
        eventCell.event = events[indexPath.item]
        return eventCell
    }
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
}
class Event {
    var name: String?
    var date: String?
    
    var description: String?
    var location: String?
    var eventImageName: String?
}
extension EventController: GMSAutocompleteViewControllerDelegate {
    
    // Handle the user's selection.
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        locationSelectButton.setTitle(place.formattedAddress, for: .normal)
        location=place.formattedAddress!
        latitude = String(place.coordinate.latitude)
        longitude = String(place.coordinate.longitude)
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress)")
        print("Place attributions: \(place.attributions)")
        
        dismiss(animated: true, completion: nil)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        // TODO: handle the error.
        print("Error: ", error.localizedDescription)
    }
    
    // User canceled the operation.
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    // Turn the network activity indicator on and off again.
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
    
}
