#!/bin/bash

# File paths and nbodies values
FILES=(
    "../../../../treelogy_synthetic_10M.txt" 
    "../../../../treelogy_synthetic_25M.txt" 
    "../../../../treelogy_synthetic_50M.txt"
)
NBODIES=(10000000 25000000 50000000)

# Number of iterations (default to 5 if not provided)
NUM_ITERATIONS=$1
if [ -z "$NUM_ITERATIONS" ]; then
    NUM_ITERATIONS=5
fi

# Build the project
make clean && make
if [ $? -ne 0 ]; then
    echo "Build failed. Exiting."
    exit 1
fi

# Loop through files and corresponding nbodies
for index in "${!FILES[@]}"; do
    FILE=${FILES[$index]}
    NBODY=${NBODIES[$index]}
    
    # Initialize variables to store cumulative times
    total_compute_cofm=0
    total_force_calc=0

    # Run the command for the specified number of iterations
    for i in $(seq 1 $NUM_ITERATIONS); do
        echo "Running iteration $i for file: $FILE with nbodies: $NBODY"

        # Capture the output of the command
        output=$(./bh "$FILE" "$NBODY")
        
        # Extract the timings for compute_cofm and force_calc
        compute_cofm=$(echo "$output" | grep "@ compute_cofm" | awk '{print $3}')
        force_calc=$(echo "$output" | grep "@ force_calc" | awk '{print $3}')

        # Add the timings to the totals
        total_compute_cofm=$((total_compute_cofm + compute_cofm))
        total_force_calc=$((total_force_calc + force_calc))
    done

    # Calculate averages
    average_compute_cofm=$((total_compute_cofm / NUM_ITERATIONS))
    average_force_calc=$((total_force_calc / NUM_ITERATIONS))

    # Calculate total execution time
    total_execution_time=$((average_compute_cofm + average_force_calc))

    # Print the results for this file
    echo "File: $FILE"
    echo "Total execution time: $total_execution_time ms"
    echo "------------------------------------------"
done
