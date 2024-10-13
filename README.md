<div align="center">
<img src="https://readme-typing-svg.herokuapp.com?color=9370DB&size=50&width=600&height=80&lines=Welcome-to-StockWise"/>
</div>

# StockWise

StockWise is a Flutter application designed to provide real-time stock quotes, manage a watchlist, and visualize historical stock price data. The app integrates with the Twelve Data API to deliver accurate financial information and includes an intuitive UI with a modern design.

## Features

- **Stock Quote Display**: View current stock prices, company names, and price changes.
- **Watchlist**: Add and remove stocks for quick access.
- **Historical Data Visualization**: Analyze historical stock price movements with charts.
- **Onboarding Screens**: Guide new users through the app with a smooth onboarding experience.

## Screenshots
![1](https://github.com/user-attachments/assets/60a258ce-9de8-476f-9ffa-095ab6e9f988)
![2](https://github.com/user-attachments/assets/dacc56b9-74e3-4dd4-b785-78081bb90ec3)
![Gray Peach Purple Green Modern Product Launch Plan Presentation](https://github.com/user-attachments/assets/7824f736-b985-45c8-a8a3-7c8bee946f22)

## Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) installed on your machine.
- A valid API key from [Twelve Data API](https://twelvedata.com/).

### Installation

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/yourusername/stockwise.git
    cd stockwise
    ```

2. **Install Dependencies:**

    ```bash
    flutter pub get
    ```

3. **Configure API Key:**

    - Replace `YOUR_API_KEY` in `lib/services/api_service.dart` with your actual Twelve Data API key.

4. **Run the App:**

    ```bash
    flutter run
    ```

## Usage

- **Onboarding Screen**: The onboarding screen introduces users to the app’s features. Once completed, users will be directed to the main screen.
- **Main Screen**: Navigate between the Home and Wishlist screens using the bottom navigation bar.
- **Search Stocks**: Use the search feature to find and view stock information.
- **Add to Watchlist**: Add stocks to your watchlist for easy access.
- **View Historical Data**: Access detailed charts to view historical stock data.

## Code Structure

- `lib/`: Contains the main codebase.
  - `models/`: Data models for stock information.
  - `screens/`: UI screens for different parts of the app.
  - `services/`: API services and data fetching logic.
  - `onboarding_screen.dart`: Onboarding screen implementation.
  - `main.dart`: Entry point of the application.

## Dependencies

- `flutter`: The Flutter SDK.
- `cupertino_icons`: For iOS styled icons.
- `provider`: State management package.
- `http`: For making HTTP requests.
- `syncfusion_flutter_charts`: For charting historical data.
- `fl_chart`: For displaying line charts.
- `shared_preferences`: For local storage of user preferences.
- `flutter_launcher_icons`: For customizing app icons.

## Development

### Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the Repository**.
2. **Create a Feature Branch**: `git checkout -b feature/new-feature`
3. **Commit Your Changes**: `git commit -am 'Add new feature'`
4. **Push to the Branch**: `git push origin feature/new-feature`
5. **Create a New Pull Request**.

### Code Style

- Use `dartfmt` to format your code.
- Follow the Dart and Flutter style guides.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgements

- Thanks to the [Twelve Data API](https://twelvedata.com/) for providing the financial data.
- Special thanks to the Flutter community for their support and resources.

---

Feel free to modify and expand this `README.md` file based on any additional details or changes in your project.

<h3 align="center">Made by <a href="https://github.com/yazdanhaider">@yazdanhaider🇮🇳</a></h3>

