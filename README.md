FormKit
============

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [Fields](#fields)
- [Credits](#credits)
- [License](#license)

## Features

- [x] Easy integration
- [x] Handles most common form entries

## Installation

### Carthage

[Carthage](https://github.com/cuba/NetworkKit) is a decentralized dependency manager that builds your dependencies and provides you with binary frameworks.

You can install Carthage with [Homebrew](http://brew.sh/) using the following command:

```bash
$ brew update
$ brew install carthage
```

To integrate FormKit into your Xcode project using Carthage, specify it in your `Cartfile`:

```ogdl
github "cuba/FormKit" ~> 1.8
```

Run `carthage update` to build the framework and drag the built `FormKit.framework` into your Xcode project.

## Usage

Here are the instructions on how to integrate form kit in your application. For a full working example, please look at the Example app in this repository.

### Integration

To integrate form kit in your ViewController extend the FormTableViewController

```swift
import FormKit

class ViewController: FormTableViewController {
    // Your view controller logic
}
```

### Setting up the content

Make sure you implement the FormDataSource protocol

```swift
extension ViewController: FormDataSource {
    func makeSections() -> [FormSection] {
        return [
            FormSection(title: "Strings", rows: [
                StringField(key: "string_field", label: "String Field", type: .text, value: "Initial value")
                ])
        ]
    }
    
    func cell(forCustomRow formRow: FormRow, at indexPath: IndexPath) -> UITableViewCell {
        // Provide cells for custom FormRows
        fatalError("You need to provide a UITableViewCell for custom FormRows")
    }
}
```

And set the form data source on the parent

```swift
class ViewController: FormTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formDataSource = self
        
        // other intialization logic ...
    }
}
```

### Listening to form changes

To get form changes, implement the FormDelegate protocol.

```swift
extension ViewController: FormDelegate {
    func updatedField(_ field: SavableField, at indexPath: IndexPath) {
        // Handle any mapping to your model
        example.map(field: field)
    }
    
    func performAction(forCustomRow row: FormRow, at indexPath: IndexPath) {
        // Implement a custom action on a row
    }
}
```

And set the form delegate on the parent

```swift
class ViewController: FormTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.formDataSource = self
        self.formDelegate = self
        
        // other intialization logic ...
    }
}
```

All built in fields except for `StandardField` implement the `SavableField` protocol and will trigger the `func updatedField(_ field: SavableField, at indexPath: IndexPath)` delegate method.

## Fields

### Built in fields

The following fields are supported:

`StringField`
`TextAreaField`
`DateField`
`NumberField`
`BoolField`
`SingleSelectField`
`MultipleSelectField`
`SignatureField`
`StandardField`

### Custom Fields

You may also create custom fields by implementing the `FormRow` protocol.

If you do this, will need to provide a cell for your custom field in the `FormDataSource` method.

```swift
func cell(forCustomRow formRow: FormRow, at indexPath: IndexPath) -> UITableViewCell {
    // Return a cell for your custom row
}
```

## Synchronizing Data

You may use the following convenience methods to syncronize your models on form changes.

```swift
myModel.name <- ("name", field)
```

For this to work your field needs to implement the `SavableField` protocol. All built in fields (except for `StandardField`) implement this protocol already.

In addition, one (and only one) field has the key `"name"`. The convienience method will ignore all fields that don't have the key provided.

### Customized mapping

If you require more customized logic, you may do the following:

```swift
if field.isField(forKey: "name") {
    let name: String? = field.saveValue()
    // Do something custom with name
}
```

## Field provider

The field provider is a quick way of setting static content on a field such as a key or title and helps in syncronizing the data back to your model. First create an object (preferrably enum) that implements the `FieldProvider` protocol.  

Here is an example:

```swift
enum SignatureFieldProvider: String, FieldProvider {
    case name               = "name"
    case date               = "date"
    case signature          = "signature"
    
    var key: String {
        return rawValue
    }
    
    var label: String {
        switch self {
        case .name              : return "Full Name"
        case .date              : return "Date signed"
        case .signature         : return "Click to sign your form"
        }
    }
    
    var options: FieldOptions {
        return [.required]
    }
}
```

### Creating fields using FieldProvider

We can create our fields easily using the field provider like this:

```swift
FormSection(title: "Signature", rows: [
    StringField(provider: SignatureFieldProvider.name, type: .text, value: myModel.name),
    DateField(provider: SignatureFieldProvider.date, type: .date, date: example.date),
    SignatureField(provider: SignatureFieldProvider.signature, image: example.signature)
    ]),
```

### Syncronizing fields using the FieldProvider

In addition we can save our fields back on our model like this:

```swift
myModel.name <- (SignatureFieldProvider.name, field)
```

or 

```swift
if field.isField(for: SignatureFieldProvider.name) {
    let name: String? = field.saveValue()
    // Do something custom with name
}
```

## Dependencies

FormKit is only usable on iOS 10 or above.

## Credits

FormKit is owned and maintained by Jacob Sikorski.

## License

FormKit is released under the MIT license. [See LICENSE](https://github.com/cuba/FormKit/blob/master/LICENSE) for details
