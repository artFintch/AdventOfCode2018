//
//  main.cpp
//  Day1
//
//  Created by Vyacheslav Khorkov on 1/12/2018.
//  Copyright © 2017 Vyacheslav Khorkov. All rights reserved.
//

#include <iostream>
#include <fstream>
#include <vector>
#include <set>
#include <algorithm>
#include <numeric>

using namespace std;

void readLines(istream& stream, vector<int>& numbers) {
    string line;
    while (getline(stream, line)) {
        numbers.push_back(atoi(line.c_str()));
    }
}

int endFrequency(const vector<int>& lines) {
    return accumulate(lines.begin(), lines.end(), 0);
}

int findTwiceFrequency(const vector<int>& numbers) {
    int sum = 0;
    set<int> seen = {0};
    while (true) {
        for (const auto& number : numbers) {
            sum += number;
            if (!seen.insert(sum).second) {
                return sum;
            }
        }
    }
    return sum;
}

int main() {
    fstream file("input.txt");

    vector<int> numbers;
    readLines(file, numbers);
    
    cout << endFrequency(numbers) << endl;
    cout << findTwiceFrequency(numbers);
    
    return 0;
}
