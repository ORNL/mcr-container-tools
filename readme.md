# MCR Tools
This repository is a collection of [Docker](https://www.docker.com/what-docker) images, [BASH](https://www.gnu.org/software/bash/) scripts, etc. developed at [Oak Ridge National Laboratory (ORNL)](https://www.ornl.gov/) designed to augment the development and deployment of [MATLAB](https://www.mathworks.com/products/matlab.html) based analytics.

# License
Original code included in this repository is released under the [MIT License](https://opensource.org/licenses/MIT), unless otherwise noted, see the included LICENSE file for details.

# Directories
* matlab : Docker image that can execute binaries compiled with [MATLAB's Compiler](https://www.mathworks.com/products/compiler.html) R2016a, via the [MATLAB Runtime (MCR)](https://www.mathworks.com/products/compiler/matlab-runtime.html), in a [CentOS 7](https://seven.centos.org/) environment.
* util : Tools to help determine Shared Object (SO) dependencies of other SO files such that the image can be rebuilt to support newer and older versions of the MCR.  See matlab/readme.md for details.