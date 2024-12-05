#include <algorithm>
#include <fstream>
#include <iostream>
#include <map>
#include <vector>

/*
 * Determine whether an update is valid, based on the set of rules.
 */
bool is_valid(std::map<int,std::vector<int>> rules, std::vector<int> update) {
    for (int i = 0; i < update.size() - 1; i++) {
        int u1 = update[i];
        int u2 = update[i+1];
        bool found = false;
        for (int mapsto : rules[u1]) {
            if (mapsto == u2) {
                found = true;
            }
        }
        if (!found) {
            return false;
        }
    }
    return true;
}

/*
 * Sum the middle values of each vector in a vector thereof.
 */
int sum_middle_values(std::vector<std::vector<int>> vec_of_vec) {
    int s = 0;
    for (auto vec : vec_of_vec) {
        s += vec[(vec.size()-1)/2];
    }
    return s;
}

int main() {

    // Create a map from entries to the entries they have rules for
    std::map<int, std::vector<int>> rules {};
    for (int i = 10; i < 100; i++) {
        rules[i] = std::vector<int> {};
    }

    // Create vectors for updates
    std::vector<std::vector<int>> updates {};

    // Bool for flagging when we switch between input formats
    bool sep = false;

    // Process input file
#ifdef TEST
    std::ifstream file("test.dat");
#else
    std::ifstream file("main.dat");
#endif
    std::string line;
    while (std::getline(file, line)) {
        if (line.length() == 0) {
            if (sep) {
                break;
            }
            sep = true;
            continue;
        }
        if (!sep) {
            // Append to the appropriate map for the rules
            int key = std::stoi(line.substr(0, 2));
            int value = std::stoi(line.substr(3, 2));
            rules[key].push_back(value);
        } else {
            // Set up the vector of vectors for the updates
            std::vector<int> update;
            while (line.length() > 0) {
                int page = std::stoi(line.substr(0, 2));
                update.push_back(page);
                line.erase(0, 3);
            }
            updates.push_back(update);
        }
    }

    // Determine the valid and invalid updates
    std::vector<std::vector<int>> valid {};
    std::vector<std::vector<int>> invalid {};
    for (auto update : updates) {
        if (is_valid(rules, update)) {
            valid.push_back(update);
        } else {
            invalid.push_back(update);
        }
    }

    // Sum middle entries of valid updates
    std::cout << "Part 1: " << sum_middle_values(valid) << std::endl;

    // Fix invalid entries
    for (auto& update : invalid) {

        // Sort by number of mappings from the page
        for (int i = 0; i < update.size(); i++) {
            for (int j = 0; j < update.size() - 1; j++) {
                int u1 = update[j];
                int u2 = update[j+1];
                int r1 = 0;
                int r2 = 0;
                for (int k : update) {
                    if (k != u1) {
                        r1 += std::count(rules[u1].begin(), rules[u1].end(), k);
                    }
                    if (k != u2) {
                        r2 += std::count(rules[u2].begin(), rules[u2].end(), k);
                    }
                }
                if (r1 < r2) {
                    std::swap(update[j],update[j+1]);
                }
            }
        }
    }

    // Sum middle entries of invalid updates
    std::cout << "Part 2: " << sum_middle_values(invalid) << std::endl;

    return 0;
}
