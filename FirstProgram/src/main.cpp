#include <iostream>
#include <climits>
#include <vector>
using namespace std;

int main() {
	// Exercise 01
	// -----------
	// int favorite_number;
	// cout << "Enter you favorite number between 1 and 100: ";
	// cin >> favorite_number;
	// cout << "Amazing!! That's my favorite number too!" << endl;

	// cout << "No really!! " << favorite_number << " is my favorite number!" << endl;
	
	// Exercise 02
	// -----------
	// int num1, num2;
	// cout << "Enter two integers separated by a space: ";
	// cin >> num1 >> num2;
	// cout << "You entered: " << num1 << " and " << num2 << endl;
	
	// Exercise 03
	// -----------
	// int num1;
	// double num3;
	// cout << "Enter an integer: ";
	// cin >> num1;
	// cout << "Enter a double: ";
	// cin >> num3;
	// cout << "You entered: " << num1 << " and " << num3 << endl;

	// Exercise 04
	// -----------
	// cout << "Enter the length of the room (in feet): ";
	// int length{0};
	// cin >> length;
	
	// cout << "Enter the width of the room (in feet): "; 
	// int width{0};
	// cin >> width;

	// cout << "The area of the room (in square feet): " << length*width << endl;

	// Exercise 05
	// -----------
	// cout << "sizeof information:" << endl;
	// cout << "===================" << endl;
	
	// cout << "char.\t\t" << sizeof(char) << "\tbyte(s)" << endl;
	// cout << "int\t\t" << sizeof(int) << "\tbyte(s)" << endl;
	// cout << "unsigned int\t" << sizeof(unsigned int) << "\tbyte(s)" << endl;
	// cout << "short\t\t" << sizeof(short) << "\tbyte(s)" << endl;
	// cout << "long\t\t" << sizeof(long) << "\tbyte(s)" << endl;
	// cout << "long long\t" << sizeof(long long) << "\tbyte(s)" << endl;
	// cout << "float\t\t" << sizeof(float) << "\tbyte(s)" << endl;
	// cout << "double\t\t" << sizeof(double) << "\tbyte(s)" << endl;
	// cout << "long double\t" << sizeof(long double) << "\tbyte(s)" << endl;	
	// cout << "char. min.\t\t" << CHAR_MIN << endl;
	// cout << "int min.\t\t" << INT_MIN << endl;
	// cout << "short min.\t\t" << SHRT_MIN << endl;
	// cout << "long min.\t\t" << LONG_MIN << endl;
	// cout << "long long min.\t\t" << LLONG_MIN << endl;
	// cout << "char. max.\t\t" << CHAR_MAX << endl;
	// cout << "int max.\t\t" << INT_MAX << endl;
	// cout << "short max.\t\t" << SHRT_MAX << endl;
	// cout << "long max.\t\t" << LONG_MAX << endl;
	// cout << "long long max.\t\t" << LLONG_MAX << endl;		

	// Exercise 06
	// -----------
	// cout << "Hello, welcome to Frank's Carpet Cleaning Service" << endl;
	// cout << "\nHow many rooms would you like cleaned?" << endl;
	
	// int number_of_rooms {0};
	// cin >> number_of_rooms;
	
	// const double price_per_romm {30.0};
	// const double sales_tax {0.06};
	// const int estimate_expiry {30};
	
	// cout << "\nEstimate for carpet cleaning service" << endl;
	// cout << "Number of rooms: " << number_of_rooms << endl;
	// cout << "Price per room: $" << price_per_romm << endl;
	// cout << "Cost: $" << price_per_romm* number_of_rooms << endl;
	// cout << "Tax: $" << price_per_romm * number_of_rooms * sales_tax << endl;
	// cout << "=============================================" << endl;
	// cout << "Total estimate: $" << price_per_romm * number_of_rooms * (1 + sales_tax) << endl;
	// cout << "This estimate is valid for " << estimate_expiry << " days" << endl;

	// Exercise 07
	// -----------
	// char vowels[] {'a', 'e', 'i', 'o', 'u'};
	// cout << "\nTh first vowel is: " << vowels[0] << endl;
	// cout << "Th last vowel is: " << vowels[4] << endl;

	// Exercise 08	
	// -----------
	// vector <char> vowels {'a', 'e', 'i', 'o', 'u'};
	// cout << "\nThe first vowel is: " << vowels.at(0) << endl;
	
	// vector <int> test_scores {100, 95, 99};
	// test_scores.push_back(80);
	// test_scores.push_back(90);
	
	// cout << "\nThe sixth test scores: " << test_scores.at(4) << endl;
	// cout << "There are " << test_scores.size() << " test scores in the vector." << endl;

	// Exercise 09
	// -----------	
	// vector <vector<int>> movie_ratings
	// {
		// {1,2,3,4},
		// {1,2,4,4},
		// {1,3,4,5}
	// };
	
	// cout << "Here is the movies ratings for viewer #1 using array syntax:" << endl;
	// cout << movie_ratings[0][0] << endl;
	// cout << movie_ratings[0][1] << endl;
	// cout << movie_ratings[0][2] << endl;
	// cout << movie_ratings[0][3] << endl;

	// cout << "\nHere is the movies ratings for viewer #1 using vector syntax:" << endl;
	// cout << movie_ratings.at(0).at(0) << endl;
	// cout << movie_ratings.at(0).at(1) << endl;	
	// cout << movie_ratings.at(0).at(2) << endl;	
	// cout << movie_ratings.at(0).at(3) << endl;	

	// Exercise 10
	// -----------
	// vector <int> vector1 {10,20};
	// vector <int> vector2 {100, 200};
	// vector <vector<int>> vector_2d {};
	
	// vector_2d.push_back(vector1);
	// vector_2d.push_back(vector2);
	
	// vector1.at(0) = 1000;
	
	// cout << vector_2d[0][0] << endl;
	// cout << vector_2d[0][1] << endl;
	// cout << vector_2d[1][0] << endl;	
	// cout << vector_2d[1][1] << endl;

	// Exercise 11
	// -----------
	// const double usd_per_eur {1.19};
	
	// cout << "Welcome to EUR to USD Converter" << endl;
	// cout << "Enter the value in EUR: ";
	
	// double euros {0.0};
	// double dollars {0.0};
	
	// cin >> euros;
	// dollars = euros * usd_per_eur;
	
	// cout << euros << " EUR is equivalent to " << dollars << " USD." << endl;

	// Exercise 12
	// -----------
	// int total{}, num1{}, num2{}, num3{};
	// const int count {3};
	
	// cout << "Enter " << count << " integers, separated by spaces: ";
	// cin >> num1 >> num2 >> num3;
	
	// total = num1 + num2 + num3;
	
	// double average {0.0};
	// average = static_cast<double>(total)/count;
	
	// cout << "Sum: " << total << endl;
	// cout << "Average: " << average << endl;

	// Exercise 12
	// -----------
	// bool equal_result {false};
	// bool not_equal_result {false};
	// int num1{}, num2{};
	// cout << boolalpha;
	
	// cout << "Enter two integers separated by a space: ";
	// cin >> num1 >> num2;
	// equal_result = (num1 == num2);
	// not_equal_result = (num1 != num2);
	
	// cout << "Comparison result (equal): " << equal_result << endl;
	// cout << "Comparison result (not equal): " << not_equal_result << endl;	

	// Exercise 13
	// -----------
	// int num {};
	// const int lower{10};
	// const int upper{20};
	
	// cout << boolalpha;
	
	// cout << "Enter an integer - the bounds are " << lower << " and " << upper <<": ";
	// cin >> num;
	
	// bool within_bounds{false};
	
	// within_bounds = (num> lower && num < upper);
	// cout << num << " is between " << lower << " and " << upper << ": " << within_bounds << endl;

	// Exercise 14
	// -----------
	const int dollar_value {100};
	const int quarter_value {25};
	const int dime_value {10};
	const int nickel_value {5};
	
	int change_amount {};
	
	cout << "Enter an amount in cents: ";
	cin >> change_amount;
	
	int balance {}, dollars {}, quarters {}, dimes {}, nickels {}, pennies {};
	
	dollars = change_amount/dollar_value;
	balance = change_amount%dollar_value;
	
	quarters = balance/quarter_value;
	balance = balance%quarter_value;
	
	dimes = balance/dime_value;
	balance = balance%dime_value;
	
	nickels  = balance/nickel_value;
	balance = balance%nickel_value;
	
	pennies = balance;
	
	cout << "\nYou can provide this change as follows: " << endl;
	cout << dollars << " dollar" << endl;
	cout << quarters << " quarter" << endl;
	cout << dimes << " dime" << endl;	
	cout << nickels << " nickel" << endl;	
	cout << pennies << " penny" << endl;
	cout << endl;
    return 0;
}
