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
    std::vector<float> interpolatedValues(yMax * xMax);

    // find the correct spacing to figure out where we need to interpolate
    float x_spacing = (sideSize - 1) / (xMax - 1);
    float y_spacing = (sideSize - 1) / (yMax - 1);

    // Loop over y and x dimensions to find all the positions we are going to place glyphs in
    for (size_t y = 0; y < yMax; y++)
    {
        for (size_t x = 0; x < xMax; x++)
        {
            // calculate the current x and y positions
            float posX = x * x_spacing;
            float posY = y * y_spacing;

            // x0 is the column position and y0 the row of the bottom right corner
            size_t x0 = std::floor(posX);
            size_t y0 = std::floor(posY);
            // Taking into account that x0+1 can step outside the coordinate system; we take sideSize-1 if that should happen
            size_t x1 = std::min(x0 + 1, sideSize - 1);
            size_t y1 = std::min(y0 + 1, sideSize - 1);

            float x_diff = posX - x0;
            float y_diff = posY - y0;

            // values at the corners
            // bottom row
            float f00 = values[y0 * sideSize + x0];
            float f10 = values[y0 * sideSize + x1];
            // top row
            float f01 = values[y1 * sideSize + x0];
            float f11 = values[y1 * sideSize + x1];

            // interpolate along the X axis on the bottom and top row
            float r0 = (1 - x_diff) * f00 + x_diff * f10;
            float r1 = (1 - x_diff) * f01 + x_diff * f11;

            // interpolate along the y direction given the above calculated values
            interpolatedValues[y * xMax + x] = (1 - y_diff) * r0 + y_diff * r1;
        }
    }

    return interpolatedValues;
}
}

#endif // INTERPOLATION_H
