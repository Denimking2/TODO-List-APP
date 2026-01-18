#include <iostream>
#include <vector>
#include <chrono>
#include <string>
#include <cstring>
#include <algorithm>

extern "C" {
    
    // Function to calculate sum (called from Java via JNI)
    JNIEXPORT jdouble JNICALL
    Java_com_example_todo_MainActivity_nativeCalculate(
        JNIEnv* env, jobject thiz, jdoubleArray numbers) {
        
        jsize length = env->GetArrayLength(numbers);
        jdouble* elements = env->GetDoubleArrayElements(numbers, nullptr);
        
        double sum = 0.0;
        for (int i = 0; i < length; i++) {
            sum += elements[i];
        }
        
        env->ReleaseDoubleArrayElements(numbers, elements, 0);
        return sum;
    }
    
    // C++ Todo class
    class TodoItem {
    public:
        std::string title;
        long timestamp;
        bool completed;
        
        TodoItem(const std::string& title, long timestamp) 
            : title(title), timestamp(timestamp), completed(false) {}
        
        void complete() {
            completed = true;
        }
    };
    
    class TodoManager {
    private:
        std::vector<TodoItem> todos;
        
    public:
        void addTodo(const std::string& title) {
            auto now = std::chrono::system_clock::now();
            auto timestamp = std::chrono::duration_cast<std::chrono::milliseconds>(
                now.time_since_epoch()).count();
            
            todos.emplace_back(title, timestamp);
        }
        
        int getTodoCount() const {
            return todos.size();
        }
        
        double calculateAveragePriority() const {
            if (todos.empty()) return 0.0;
            
            // Simulate priority calculation
            double total = 0.0;
            for (const auto& todo : todos) {
                total += todo.title.length() * 0.1; // Example calculation
            }
            return total / todos.size();
        }
        
        // Function to process numbers (called from Flutter via platform channels)
        const char* processNumbers(const double* numbers, int count) {
            static std::string result;
            result = "C++ Result:\n";
            
            double sum = 0.0;
            double max = numbers[0];
            double min = numbers[0];
            
            for (int i = 0; i < count; i++) {
                sum += numbers[i];
                if (numbers[i] > max) max = numbers[i];
                if (numbers[i] < min) min = numbers[i];
            }
            
            result += "Sum: " + std::to_string(sum) + "\n";
            result += "Average: " + std::to_string(sum / count) + "\n";
            result += "Max: " + std::to_string(max) + "\n";
            result += "Min: " + std::to_string(min) + "\n";
            result += "Total todos in C++: " + std::to_string(getTodoCount());
            
            return result.c_str();
        }
    };
    
    // C interface for Swift/Flutter
    extern "C" double calculateWithCpp(const double* numbers, int count) {
        double sum = 0.0;
        for (int i = 0; i < count; i++) {
            sum += numbers[i];
        }
        return sum;
    }
}