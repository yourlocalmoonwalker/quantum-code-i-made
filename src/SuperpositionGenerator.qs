namespace SuperpositionGenerator{
    //Quantum Libraries
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Canon;

    //Necessary for forcing Qubit states
    operation SetQubitState (desired: Result, target : Qubit): Unit {
        if desired != M(target){
            X(target)
        }
    }


    @EntryPoint()
    operation CheckState() : (Int, Int, Int, Int, Int, Int){
        
        //Variables which will be used for information
        mutable numOnesQ1=0;
        mutable numOnesQ2=0;
        mutable difference=0;
        mutable difference2=0;

        let count = 1; //How many times the Qubit's superposition should be measured
        let initial = One; //The variable for setting a Qubit's state to be 'One'

        use (q1,q2) = (Qubit(),Qubit()); //Allocating the Qubits
        for test in 1..count {
            SetQubitState(initial, q1);
            SetQubitState(Zero, q2);
            
            //Superpositioning the Qubits
            H(q1);
            H(q2);

            let resultQ1 = M(q1); //Instantly checks the first Qubit's state
            let resultQ2 = M(q2); //Instantly checks the second Qubit's state

            //If a Qubit's state is 'One' then we increase the variables
            if resultQ1 == One { 
                set numOnesQ1 += 1;
            }
            if resultQ2 == One {
                set numOnesQ2 += 1;
            }
        }
        //Checks the difference between the amount of Ones and Zeroes in the Qubits
        //(If it's negative then the second one is bigger, vice versa)
        set difference = (numOnesQ1 - numOnesQ2);
        set difference2 = ((count - numOnesQ1) - (count - numOnesQ2));

        //Resets the Qubits
        SetQubitState(Zero, q1);
        SetQubitState(Zero, q2);

        //Sends the information to the Debug Console
        Message($"Q1 - Ones: {numOnesQ1}");
        Message($"Q2 - Ones: {numOnesQ2}");
        Message($"Q1 - Zeros: {count - numOnesQ1}");
        Message($"Q2 - Zeros: {count - numOnesQ2}");
        Message($"Difference in ones: {difference}");
        Message($"Difference in zeroes: {difference2}");
        return (numOnesQ1, numOnesQ2, count - numOnesQ1,  count - numOnesQ2,  difference, difference2);
    }
}