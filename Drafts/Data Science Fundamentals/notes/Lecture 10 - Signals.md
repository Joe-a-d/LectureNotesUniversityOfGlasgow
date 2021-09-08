# Lecture 10 - Signals

# Summary
By the end of this unit you should know:

what sampling is, for 1D and 2D signals
how amplitude quantization affects signals
why interpolation is needed
how to interpolate and resample digital signals correctly
how to interpolate irregular data into a digital signal format
the importance of noise and the signal-to-noise ratio
the purpose of filtering signals
how moving averages work
how median filtering works
how convolution is implemented
standard types of convolution, including smoothing
what the sampling rate and Nyquist limit are
what aliasing is, and how and when it manifests itself
what the frequency domain and time domain are and what they represent
how the Fourier transform relates the time domain to the frequency domain
what convolution is and how the Fourier transform can be used to predict its behaviour

# Time Series and Signals

- real world signals (e.g. sounds, temperature) are continuous in both value and time/space
  - imagine them as real functions of real values $x_t = x(t)$
  - **in order to represent a function into a numerical array** (hence making it amenable to digital processing) we need to sample them
  - we must have a precise, fixed number of values for both $t$ and $x(t)$

Quantisation
: to force something to a discrete set of values

![](@attachment/Clipboard_2021-07-26-00-23-18.png)

- We sample it *regularly* to obtain a sequence of measurements $x[t] = [x_1,\cdots,x_n]$
  - the timed intervals must be precisely fixed
  - each measurement records the value of $x(t)$ at instant $t$ - *time quantisation*

![](@attachment/Clipboard_2021-07-26-00-25-58.png)

- Each measurement of $x(t)$ is itself quantised to a fixed set of values (e.g. `int8` valid values) - *amplitude quantisation*

- The **goal** is to capture the essence of $x(t)$ as a 1D `ndarray` of numbers (or 2D if $x_t$ was a vector)

## Sampling - Throwing Away Time

- This sampling process and the requirement of regularly taken samples allow us to not store time
  - we store the sampled signal as a single vector with the assumption that time starts at some origin $t_0$ and increases in a fixed amount for every successively element
  - the value of $t$ is not stored and can be implicetely derived from the data stored
  - e.g. say the following array represents temperatures taken at 9AM everyday `T = [12,23,45,23]` , if we want to know the temperature on the 3rd day we retrieve `T[2]`

### Sampling Rate

Sampling Rate
: how frequently we have sampled the original data

- needs to be stored
- A sampling rate of $f_s$ means that the spacing between samples $\Delta T$ is $\frac{1}{f_s}$
  - usually specified in **Hertz** - measurements per second
  - e.g. $f_s = 100Hz$ is the same as saying that we take a measurement once every $\Delta T = 0.01s$
  - same concept in imaging, e.g. pixels per inch
- we sample because
  - compact, efficient way to represent the approximation of the continuous function
  - saves storage
  - efficient algorithms to be applied to signals
  - perform array operations on the samples
    - e.g. smoothing and regression, correlation between signals, crop/selection regions

## Noise

- measurements from the world introduces noise - $\epsilon(t)$
- our function can more accurately be represented by
$$
x(t)=y(t)+\epsilon(t)
$$

Signal to Noise Ratio
: how much of the signal we expect to be true and how much to be noise , $\text{SNR}=\frac{S}{N}$

- $S$ : the amplitude of $y(t)
- $N$ : the amplitude of $\epsilon(t)$
- this is typically represent in decibels by taking the log

### Removing noise

- Noise is by definition random, so we can't just subtract it
- We can however by making some assumptions about the generative process of $y(t)$ (how we expect it to look like) , encode that as a model and then we can try to find unexpected patterns and identify it as noise and *filter* it out

## Amplitude Quantisation

- Amplitude quantisation makes $f(t)$ discrete by reducing it to a number of distinct values
  - the number of levels used is often quoted in bits
  - the more precise the levels, the less noise is introduced

- We can plot the **residual** (difference) of the quantised signal and the original
  - this quantifies how much error the quantisation introduced
  - as seen below, the "distortion"/error introduced is completely random

![](@attachment/Clipboard_2021-07-26-00-52-13.png)

# Sampling Theory

- If we sample often enough we can perfectly reconstruct any given continuous signal
  - **fundamental**

## Nyquist Limit

- Specifically, for a given sample rate $f_s$, we can recover $x(t)$ perfectly from a sampled signal if the signal contains frequencies 8at most* $f_{n}=\frac{f_{s}}{2}$
  - this limit is know as **Nyquist limit** - $f_N$

## Aliasing

- If we don't sample often enough we *aliase* the signal
  - high-frequency components are "folded over"
  - if we sample a signal component with frequency $f_q > f_n$, we'll get an artificial component $f_n - (f_q \mod f_n)$ in the sampled signal


<p align="center"><iframe width="560" height="315" src="https://www.youtube.com/embed/OtxlQTmx1LE" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe></p>

## Filtering

- takes advantage of the fact that we have temporal structure
  - real signals cannot have arbitrary changes
  - we can code that predictive model as a filter
- A simple assumption is that there is a true process that is corrupted by noise
  - noise can be represented by a Gaussian distribution and independent at each time step
- We can then average out the contribution of the noise by averaging over multiple time steps
  - if we know that the true signal is not changing quickly taking the average won't damage the signal too much

### Sliding Window - Moving Averages 

- take a sliding window of samples and compute their mean
- slide the window along by one sample and repeat until the end is reached

$$
y[t]=\frac{1}{K} \sum_{i=0}^{n-1} x[t+i-K / 2]
$$

- this idea of a sliding window is **critical**
- we can bound a sample signal and reduce it to a collection fixed length vectors
- if we divide it into $K$ , we can process these as a $N \times K$ matrix
  - $N$ windows of $K$ samples
  - for vector valued measurements (e.g. stereo audio) we would use tensors

- the moving average filter has only one parameter - the length of the window - $K$
  - the longer the moving average, the smoother the waveform, and the more high-frequencies are suppressed

![](@attachment/Clipboard_2021-07-26-01-26-11.png)

## Nonlinear

- any filter which is not a weighted sum

### Median Filtering

- the most common nonlinear filter
  - a.k.a order filter
- just like the moving average but uses the median as the measure of central tendency of the window
- adds robustness to extreme values

## Generalising Moving Averages - Convolution and Linear Filters

### Linear

- commonly used
- any filter where the output is a weighted sum of neighbouring values and the original value
- efficient **because** CPUs often have a `multiply and accumulate` instruction
  - multiplies a value by a constant and accumulates into a register
- In 1D (e.g. time series), this might be of the form 
  - $f(x[t])=0.25 x[t-1]+0.5 x[t]+0.25 x[t+1]$
  - which is just a weighted sum of the three samples
  - the total value is still 1.0, so **the average amplitude of the signal does not change**
  - below we can see the smoothing effect, it spreads without affecting the amplitude

![](@attachment/Clipboard_2021-07-26-01-36-36.png)

## Convolution

- the process of taking weighted sums of neighbouring values
  - denoted by $*$ or $\otimes$
  - $f * g$ is the convolution of $f$ and $g$
- only defined for continuous functions

- for two sampled signal vectors $x[n],y[m]$ of length $N$ and $M$, convolution is defined as

$$
(x * y)[n]=\sum_{m=-M}^{M} x[n-m] y[m]
$$

- effects like blurring and sharpening images, filtering audio and many forms of processing scientific data all boil down to applications of convolution
  - we can see $x$ as the signal to be transformed and $y$ as the operation to be performed
  - $y$ is called the **convolution kernel**

![](https://upload.wikimedia.org/wikipedia/commons/6/6a/Convolution_of_box_signal_with_itself2.gif)

- The window "shape" are the weights applied to form the weighted sum, which is computed at each possible offset of that window.

- The moving average is just a convolution where there are $N$ elements each with values $\frac{1}{N}$

#### Algebraic Properties

- commutative
- associative
- distributive

- e.g. a smoothing edge detecting kernel created by combining an edge detector kernel and a smoothing kernel 

![](@attachment/Clipboard_2021-07-26-01-48-14.png)

![](@attachment/Clipboard_2021-07-26-01-48-19.png)

![](@attachment/Clipboard_2021-07-26-01-48-24.png)

![](@attachment/Clipboard_2021-07-26-01-48-58.png)

![](@attachment/Clipboard_2021-07-26-01-49-07.png)

![](@attachment/Clipboard_2021-07-26-01-49-02.png)

### Dirac Delta Functions

- simplest convolutions
- useful in analysing system responses

$$
\begin{array}{c}\int_{-\infty}^{\infty} \delta(x)=1 \\ \delta(x)=\left\{\begin{array}{l}0, x \neq 0 \\ \infty, x=0\end{array}\right.\end{array}
$$

![](@attachment/Clipboard_2021-07-26-01-50-22.png)

- given that we work with discrete data we need to use its discretised version
  - an array of zeros with a single 1 - **an impulse**

- w.r.t convolutions , they're key property is that their convolution does not change the original function
  - $f(x) * \delta(x) = f(x)$
  - **this means** that if we can simulate a system with the delta function we can read back the convolution that represents the linear model of that system
- if we can inject a perfect impulse into a system we can recover the convolution kernel - *linear system identification*
  - e.g. hitting a table and listening for reverberance will tell us something about its structure
- **but** there are two practical difficulties (in measurements of physical systems, not so much digital)
  - producing a *perfect* impulse
  - dealing with noise in the observations

- e.g. of application, simulating reverb in synth instruments so that they sound life-like (see nb)

# Frequency Domain

- we can view (periodic) signals in two identical ways
  - a sequence of amplitude measurements over time (what we've seen so far) - **time domain**
  - a sum of oscillations with different frequencies - **frequency domain**

- Framing it in terms of oscillations, we can represent a *pure oscillation* as a sine wave
  - $x(t)=A \sin (2 \pi \omega t+\theta)$
  - $w$ : frequency
  - $\theta$ : phase (offset to time)
  - $A$ : magnitude

- frequency is just the repetition period of a sinusoidal oscillation
  - higher -> shorter period
  - a *pure frequency* is a sine wave with a specific period/frequency

## Fourier Transform

Fourier theorem
: any repeating function can be decomposed into sine waves by approximating the sum of sinusoids

- The Fourier transform lets us write every real signal as a sum of sinusoid functions
  - this allow us to take a signal represent it as a sequence of values in the time domain and transform it into the frequency domain and back again

$$
x(t)=\sum_{i} A_{i} \sin \left(\omega_{i} 2 \pi t+\theta_{i}\right)
$$

> KEY IDEA : we can decompose a signal into a collection of oscillations, by comparing that signal with oscillations at every possible frequency and by summing those oscillations we can our signal back. We can switch between the frequency and time domain

### Correlation between signals

- If we want to measure the similarity between two sampled signals $a[t], b[t]$ we can compute their elementwise product
  - $c=\sum_{t} a[t] b[t]$ - unnormalised correlation between two signals (inner product)
    - $c \approx 0$ - unrelated
    - $c$ large, positive - closely related
    - $c$ large, negative - inverses

### Transform

- if we generate every possible frequency of sine wave as sample signals $a_1[t],\cdots$ and correlate each with a test signal $b[t]$
  - by performing this comparison we can get the **amplitude/magnitude** of the response to that frequency
- in order to find the phase (the shift) we repeat this process by comparing with a sine wave and a cosine wave
  - $a[t] = \sin(wx)$ - to compute $c(w)$
  - $a'[t] = \cos(wx) = \sin(wx + \frac{\pi}{2}$ - to compute $c'(w)$
  - we can then work out the phase directly from the correlation with their value - *quadrature*
    - two sinusoids 90 degrees out of phase with each other

- We define phase to be the angle of the vector formed by these two values
  - $\theta=\tan ^{-1}\left(\frac{c(\omega)}{c^{\prime}(\omega)}\right)$
- To get the magnitude (ignoring the phase) we compute
  - $A=\sqrt{c(\omega)^{2}+\left(c^{\prime}(\omega)\right)^{2}}$

### Equation

$$
\hat{f}(\omega)=\int_{-\infty}^{\infty} f(x) e^{-2 \pi i x \omega} d x
$$

- it returns a complex value for each possible frequency $w$
- for real signals we can deal with only the real part of the input signal
  - by fixing $\omega$ to be some signal e.g. 10Hz), the model tells us how much response there is in the original signal $f(x)$ to that frequency. It does that by
    - taking a signal, oscillating at 10Hz, multiplying by that signal and summing the result
    - by doing that for both the sin and cos waves, we get both the phase and the amplitude

> Essentially, the Fourier transform "compares" a function with every possible frequency of sine and cosine wave, and returns how much of that frequency is present and what "phase" the sinusoidal wave is in. The sine part and the cosine part are returned as the real and imaginary components of this value

#### Inverse

- reconstitute the sinusoids exactly into the original function

$$
f(x)=\int_{-\infty}^{\infty} \hat{f}(\omega) e^{2 \pi i x \omega} d \xi
$$



## Discrete Fourier Transform

- discrete version for a vector of data $[x_0,\cdots,x_{N-1}]$

$$
\begin{array}{c}F[k]=\sum_{j=0}^{N-1} x[j] e^{-2 \pi i \frac{j}{N}} \\ =\sum_{j=0}^{N-1}\left[x[j] \cos \left(-2 \pi \frac{j}{N}\right)+i x[j] \sin \left(-2 \pi \frac{j}{N}\right)\right]\end{array}
$$

### Complex components : phase and magnitude

- the result of DFT is a sequence of complex numbers $F[k] = a + bi$
  - we can write this complex number as a magnitude $A$  and an angle $\theta$ (phase)
- the frequency of the component is given by the $k$ index, dependent on the sampling rate $X_0 = 0$ and $X_{N/2} = f_n$
  - hence, for the $k$th component the real frequency in terms of the orginal signal is 
    - $\text{freq} = f_N k/N$
- This gives us an amplitude and phase *for each* component between 0 and $f_N$ in *evenly spaced subdivisions*, with as many subdivisions as there were elements of $x[t]$

![](@attachment/Clipboard_2021-07-26-13-51-09.png)

- when analysing the results above we can ignore the observations past the reflection point since that is just a consequence of using DFT for real signals
  - when applying DFT to 100 samples we get 100 complex numbers, 200 real numbers
  - we ignore the complex part which results in this symmetry

![](@attachment/Clipboard_2021-07-26-13-55-21.png)

- the image on top represents 15 oscillations combined. Note how the Fourier transform captures the 15 peaks

## FFT

- DFT is very expensive to compute $(O(N^2))$
- An cheaper alternative is the Fast Fourier Transform
  - uses divide-and-conquer
  - $O(N\log N)$ if $N$ is a power of two

> (John Williamsonism) The FFT was discovered in its current form in the 1960s and became so important in engineering that it was called "the most important algorithm of the 20th century". It was, however, known to Gauss by 1810, *who thought it so unimportant he did not even publish it*

## Convolution Theorem

- the Fourier transform of the convolution of two signals is equal to the elementwise product of the Fourier transform of two signals

$$
\mathrm{FT}(f(x) * g(x))=\mathrm{FT}(f(x)) \mathrm{FT}(g(x))
$$

- this means that we can compute the convolution in $O(N\log N)$ using the FFT
  - it interchanges convolution and multiplication

$$
f(x) * g(x)=\operatorname{IFT}[\mathrm{FT}(f(x)) \mathrm{FT}(g(x))]
$$


## Frequency Domain and Filtering

- we are able to filter signals using FT
  - any linear filter (the effect of a convolution) it's going to be some change of the frequencies which are present in the signal
  - filters don't add frequencies to a signal because convolution is just multiplying existing frequencies in the Fourier domain
  - $\text{FT}(f * g) = \text{FT}(f)\text{FT}(g)$, if any element of $\text{FT}(f)$ is zero it will always stay zero, regardless of $g$

### Example

- motivation is understanding how we can design a filter which let us isolate the interesting parts of the data by
  - specifying in the frequency domain which frequencies we want to (d)emphasise
  - apply the FT to convert that specification to a convolution kernel which can be apllied to our digital signal

- we see that the data below looks like it is oscillating, so we can see that we can use FT in order to isolate those oscillations

![](@attachment/Clipboard_2021-07-26-14-24-00.png)

- below we see that every 10 or so years there us a cycle

![](@attachment/Clipboard_2021-07-26-14-24-08.png)

#### Analysis from a frequency perspective

- we can assume that this emergent phenomena is generated by many processes summed together
  - e.g. random fluctuations varying from day to day (high freq) ; slow death of the sun , i.e. long term trends (low freq)
- these different components would occupy different parts of the frequency spectrum
  - again here we see a peak around 0.1 (every 10y)

![](@attachment/Clipboard_2021-07-26-14-39-32.png)

- we can extract the signal region by masking in frequency space
  - convert to time domain using the inverse FT 
  - convolve

- For our mask we'll use a Gaussian function

![](@attachment/Clipboard_2021-07-26-14-43-05.png)

- We now take this frequency domain representation and covert it to the time domain using the IFT in order to get our convolution kernel which we can apply to the original signal

![](@attachment/Clipboard_2021-07-26-14-43-54.png)

![](@attachment/Clipboard_2021-07-26-14-44-00.png)

- if we look at this filtered signal in the frequency domain again we can see that the filter did what we wanted
  - the frequencies of interest have been preserved
  - the noise has been damped down