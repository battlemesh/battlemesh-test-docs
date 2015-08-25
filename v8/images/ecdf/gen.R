# Copyright (c) 2015 by Matthieu Boutier <boutier@univ-paris-diderot.fr>
#                       University of Paris Diderot

# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

open_device <- function(filename, type) {
    filename <- sub(paste(".", type, "$", sep=""), "", filename)
    filename = paste(filename, type, sep=".");
    print(paste("drawing:", filename))
    f_pixels <- function() {
        do.call(type, list(file = filename, width = flag_width,
                height = flag_height, units = "in", res = 300))
    }
    f_other <- function() {
        do.call(type, list(file = filename, width = flag_width,
                height = flag_height))
    }
    if(Sys.info()[["sysname"]] == "Darwin") {
        f_quartz <- function() {
            quartz(file = filename, width = flag_width,
                   height = flag_height, type = type, dpi=300)
        }
        # On MacOS, the best is to use quartz.
        tryCatch(f_quartz(), error = function(e) { f_other() })
    } else {
        # Works on Linux:
        tryCatch(f_pixels(), error = function(e) {f_other()})
    }
}

project <- function(f, x_val) {
    y_val <- f(x_val)
    segments(x_val, rep(0, length(x_val)), x_val, y_val, lty = 3,
             col = "darkgrey")
    segments(rep(0, length(x_val)), y_val, x_val, y_val, lty = 3,
             col = "darkgrey")
}

flag_size <- 3
flag_width <- 1.6 * flag_size
flag_height <- 1 * flag_size

open_device("simple", "svg")
par(mfrow = c(1, 1), mar = c(2,2,0,0) + 0.1)
f <- function(x) pnorm(x, 30, 8)
plot(f, 0, 60, xlab="", ylab="")
project(f, c(37, 50))
rc <- dev.off()

open_device("segment", "svg")
par(mfrow = c(1, 1), mar = c(2,2,0,0) + 0.1)
plot(c(0, 60), c(0, 1), xlab="", ylab="", type="l")
rc <- dev.off()

open_device("bearing", "svg")
par(mfrow = c(1, 1), mar = c(2,2,0,0) + 0.1)
f <- function(x) pnorm(x, 20, 3) * .4 + pnorm(x, 60, 3) * .6
plot(f, 0, 80, xlab="", ylab="")
project(f, c(20, 60))
rc <- dev.off()

sample <- c(3, 2, 2, 3, 1, 2, 5, 2)

bak <- flag_height
flag_height <- 1
open_device("distrib", "svg")
par(mfrow = c(1, 1), mar = c(2,3,0,0) + 0.1)
f <- function(x) pnorm(x, 30, 8)
plot(sample, rep(0, 8), xlab="", ylab="", axes=FALSE)
axis(1)
box(bty="o")
rc <- dev.off()
flag_height <- bak

ssample <- sort(sample)
agg <- aggregate(ssample, FUN=length, by=list(xx=ssample))
open_device("hist", "svg")
par(mfrow = c(1, 1), mar = c(2,3,0,0) + 0.1)
plot(0, type="n", xlab="", ylab="", main="",
     xlim=c(0, max(agg$xx)), ylim = c(0, max(agg$x)))
axis(1)
mtext("sample count", 2, line = 2, las = 0)
box(bty="o")
segments(agg$xx, rep(0, nrow(agg)), agg$xx, agg$x, lwd = 5)
rc <- dev.off()

open_device("ecdf", "svg")
par(mfrow = c(1, 1), mar = c(2,3,0,0) + 0.1)
plot(agg$xx, cumsum(agg$x) / length(sample), xlab="", ylab="",
     xlim=c(0, max(agg$xx)), ylim = c(0, 1), type="s")
par(new = TRUE)
plot(agg$xx, cumsum(agg$x) / length(sample), xlab="", ylab="",
     xlim=c(0, max(agg$xx)), ylim = c(0, 1))
rc <- dev.off()

bak <- flag_width
flag_width <- 2 * flag_width
open_device("trailing", "svg")
par(mfrow = c(1, 2), mar = c(3,3,1,1) + 0.1)
f <- function(x) pnorm(x, 10, 1) * .2 + pnorm(x, 40, 3) * .8
g <- function(x) c(rnorm(x * .1, 10, 1), rnorm(x *.8, 40, 3), rnorm(x * .1, 10, 1))
time <- 1:1000 / 10
sample <- g(1000)
plot(f, 0, 50, xlab="", ylab="")
plot(time, sample, xlab="", ylab="")
rc <- dev.off()
flag_width <- bak
