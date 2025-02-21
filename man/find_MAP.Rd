% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/find_MAP.R
\name{find_MAP}
\alias{find_MAP}
\title{Find the Maximum A Posteriori Estimation}
\usage{
find_MAP(
  g,
  max_iter = NA,
  optimizer = NA,
  show_progress_bar = TRUE,
  return_probabilities = FALSE
)
}
\arguments{
\item{g}{Object of a \code{gips} class}

\item{max_iter}{Number of iterations for an algorithm to perform.
At least 2. For \code{optimizer=="MH"} it has to be finite;
for \code{optimizer=="HC"} it can be infinite;
for \code{optimizer=="BF"} it is not used.}

\item{optimizer}{The optimizer for the search of the maximum posteriori.
\itemize{
\item \code{"MH"} (the default for unoptimized \code{g}) - Metropolis-Hastings
\item \code{"HC"} - Hill Climbing
\item \code{"BF"} - Brute Force
\item \code{"continue"} (the default for optimized \code{g}) - The same as
the \code{g} was optimized by (see Examples).
}

For more details, see the "Possible algorithms to use as optimizers"
section below.}

\item{show_progress_bar}{A boolean.
Indicate whether or not to show the progress bar.
\itemize{
\item When \code{max_iter} is infinite, \code{show_progress_bar} has to be \code{FALSE}.
\item When \code{return_probabilities==TRUE}, then
shows the second progress bar for the time
when the probabilities are calculated
}}

\item{return_probabilities}{A boolean. TRUE can only be provided for:
\itemize{
\item \code{optimizer=="MH"} - use Metropolis-Hastings results to
estimate posterior probabilities
\item \code{optimizer=="BF"} - use brute force results to
calculate exact posterior probabilities;
this is costly, so additional progress bar is shown
(when \code{show_progress_bar==TRUE})
}}
}
\value{
Returns an optimized object of a \code{gips} class.
}
\description{
Use one of the optimization algorithms to find the permutation that maximizes
a posteriori based on observed data. Not all optimization algorithms will
always find the MAP, but they try to find a significant value.
More information can be found in the
'Possible algorithms to use as optimizers' section below.
}
\section{Possible algorithms to use as optimizers}{

\itemize{
\item \code{"Metropolis_Hastings"}, \code{"MH"} - to use Metropolis-Hastings algorithm;
\href{https://en.wikipedia.org/wiki/Metropolis–Hastings_algorithm}{see Wikipedia}.
The algorithm will draw a random transposition in every iteration
and consider changing the current one.
When the \code{max_iter} is reached, the algorithm will return
the MAP Estimator as the best permutation calculated so far.
\item \code{"hill_climbing"}, \code{"HC"} - to use hill climbing algorithm;
\href{https://en.wikipedia.org/wiki/Hill_climbing}{see Wikipedia}.
The algorithm will check all transpositions in every iteration and
go to the one with the biggest a posteriori value.
The optimization ends when all \emph{neighbors} will have a smaller
a posteriori value. If the \code{max_iter} is reached before the end,
then the warning is shown, and it is recommended to start
the optimization again on the output of the \code{find_MAP()}.
Remember that there are \code{p*(p-1)/2} transpositions to be checked
in every iteration. For bigger \code{p}, this may be costly.
\item \code{"brute_force"}, \code{"BF"}, \code{"full"} - to use the Brute Force algorithm that
checks the whole permutation space of a given size. This algorithm will
definitely find the Maximum A Posteriori Estimation but is very
computationally expensive for bigger space.
}
}

\examples{
require("MASS") # for mvrnorm()

perm_size <- 6
mu <- runif(6, -10, 10) # Assume we don't know the mean
sigma_matrix <- matrix(
  data = c(
    1.0, 0.8, 0.6, 0.4, 0.6, 0.8,
    0.8, 1.0, 0.8, 0.6, 0.4, 0.6,
    0.6, 0.8, 1.0, 0.8, 0.6, 0.4,
    0.4, 0.6, 0.8, 1.0, 0.8, 0.6,
    0.6, 0.4, 0.6, 0.8, 1.0, 0.8,
    0.8, 0.6, 0.4, 0.6, 0.8, 1.0
  ),
  nrow = perm_size, byrow = TRUE
) # sigma_matrix is a matrix invariant under permutation (1,2,3,4,5,6)
number_of_observations <- 13
Z <- MASS::mvrnorm(number_of_observations, mu = mu, Sigma = sigma_matrix)
S <- cov(Z) # Assume we have to estimate the mean

g <- gips(S, number_of_observations)

g_map <- find_MAP(g, max_iter = 10, show_progress_bar = FALSE, optimizer = "MH")
g_map

g_map2 <- find_MAP(g_map, max_iter = 10, show_progress_bar = FALSE, optimizer = "continue")

if (require("graphics")) {
  plot(g_map2, type = "both", logarithmic_x = TRUE)
}

g_map_BF <- find_MAP(g, show_progress_bar = FALSE, optimizer = "BF")
summary(g_map_BF)
}
\seealso{
\itemize{
\item \code{\link[=gips]{gips()}} - The constructor of a \code{gips} class.
The \code{gips} object is used as the \code{g} parameter.
\item \code{\link[=plot.gips]{plot.gips()}} - Practical plotting function for
visualizing the optimization process.
\item \code{\link[=summary.gips]{summary.gips()}} - The function that summarizes the output of optimization.
\item \code{\link[=get_probabilities_from_gips]{get_probabilities_from_gips()}} - When
\code{find_MAP(return_probabilities = TRUE)} was called,
then those probabilities can be extracted with this function.
\item \code{\link[=log_posteriori_of_gips]{log_posteriori_of_gips()}} - The function that the optimizers
of \code{find_MAP()} tries to find the argmax of.
}
}
