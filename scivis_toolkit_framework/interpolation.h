#ifndef INTERPOLATION_H
#define INTERPOLATION_H

#include <cmath>
#include <vector>

#include <QDebug>

namespace interpolation
{
    /* Input
     * values: You may assume this is of the type std::vector<float>. This contains the values (e.g. densities) to be interpolated.
     * sideSize: The input size of the square matrix "values". This is equal to m_DIM in the Simulation and Visualization classes.
     * xMax, yMax: The desired dimensions of the output vector. xMax is the horizontal size (number of columns), yMax is the vertical size (number of rows).
     *
     * Output
     * interpolatedValues: A 1D row-major container of std::vector<float> type containing the interpolated values.
     */
    template <typename inVector>
    std::vector<float> interpolateSquareVector(inVector const &values, size_t const sideSize, size_t const xMax, size_t const yMax)
{
    std::vector<float> interpolatedValues(yMax * xMax, 0.0f); // Initialize output vector with 0

    float x_ratio = static_cast<float>(sideSize - 1) / (xMax - 1);
    float y_ratio = static_cast<float>(sideSize - 1) / (yMax - 1);

    for (size_t j = 0; j < yMax; ++j)
    {
        for (size_t i = 0; i < xMax; ++i)
        {
            // Map the position in the output grid to the input grid
            float src_x = i * x_ratio;
            float src_y = j * y_ratio;

            // Get the integer and fractional parts
            size_t x1 = static_cast<size_t>(src_x);
            size_t y1 = static_cast<size_t>(src_y);
            size_t x2 = std::min(x1 + 1, sideSize - 1);
            size_t y2 = std::min(y1 + 1, sideSize - 1);

            float x_diff = src_x - x1;
            float y_diff = src_y - y1;

            // Get the values at the four corners
            float Q11 = values[y1 * sideSize + x1];
            float Q21 = values[y1 * sideSize + x2];
            float Q12 = values[y2 * sideSize + x1];
            float Q22 = values[y2 * sideSize + x2];

            // Perform bilinear interpolation
            float R1 = (1 - x_diff) * Q11 + x_diff * Q21; // Interpolation in the x-direction (top row)
            float R2 = (1 - x_diff) * Q12 + x_diff * Q22; // Interpolation in the x-direction (bottom row)
            float P = (1 - y_diff) * R1 + y_diff * R2;    // Interpolation in the y-direction

            // Assign the interpolated value to the output
            interpolatedValues[j * xMax + i] = P;
        }
    }

    return interpolatedValues;
}
}

#endif // INTERPOLATION_H
