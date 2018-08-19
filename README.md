FormKit
============

- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
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

To get form changes, implement the FormDelegate protocol

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

## Dependencies

FormKit is only usable on iOS 10 or above.

## Credits

FormKit is owned and maintained by Jacob Sikorski.

## License

FormkKit is released under the MIT license. [See LICENSE](https://github.com/cuba/NetworkKit/blob/master/LICENSE) for details
