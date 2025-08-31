# Never Full Price

This project is a Ruby-based implementation of a supermarket checkout system that can apply promotional rules to a shopping basket.

## Getting Started

### Prerequisites

*   Ruby (version 3.3 or newer is recommended)
*   Bundler

## Running the Test Suite

The project uses RSpec for testing. A convenience script has been created to simplify the process.

1.  Make sure the test script is executable:

    ```sh
    chmod +x bin/test
    ```

2.  Run the entire test suite with the following command:

    ```sh
    ./bin/test
    ```

## Using the Interactive Console

An interactive console powered by `pry` is available for you to experiment with the application's components in real time.

1.  First, ensure the script is executable:

    ```sh
    chmod +x bin/up
    ```

2.  Launch the console:

    ```sh
    ./bin/up
    ```

### Console Options

You can start the console with pre-loaded data and configurations by passing optional arguments.

#### `with_catalogue`

This option pre-populates the product catalogue with a default set of items, so you don't have to create them manually.

#### `with_strategy`

This option creates a `PriceStrategy` instance, which will be available in the console as the `$strategy` variable. You can specify which promotional rules to include.

*   **To include all available promos:**

    ```sh
    ./bin/up with_strategy all_promos
    ```

*   **To include a specific list of promos:** (Provide the class names as arguments)

    ```sh
    ./bin/up with_strategy GreenTeaOnMe DiscountoChino
    ```

### Example: Interacting with the Checkout

Here is a practical example of how to simulate a shopping experience using the interactive console.

1.  **Start the console** with the catalogue and all promotion rules loaded:

    ```sh
    ./bin/up with_catalogue with_strategy all_promos
    ```

2.  **Create a new checkout instance**. It will automatically be configured with the loaded `$strategy`:

    ```ruby
    checkout = App::Checkout.new(price_strategy: $strategy)
    ```

3.  **Scan some items**. Let's replicate one of the test cases (`GR1, SR1, GR1, GR1, CF1`):

    ```ruby
    checkout.scan('GR1')
    checkout.scan('SR1')
    checkout.scan('GR1')
    checkout.scan('GR1')
    checkout.scan('CF1')
    ```

4.  **Check the total price**. The checkout will apply the promotional rules (e.g., "buy-one-get-one-free" for Green Tea) and calculate the final price:

    ```ruby
    checkout.total
    # => 22.45
    ```

5.  You can also **inspect the basket's contents** at any time:

    ```ruby
    checkout.basket.items
    ```

6.  **Remove an item** from the basket and see how the total is updated:

    ```ruby
    checkout.remove('GR1')
    checkout.total
    # The new total will be calculated based on the remaining items.
    ```