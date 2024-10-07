# Molten and markdown example

> [!TIP]
> Evaluate a fenced block or a selection of code with `<S-Enter>`.

# Markdown images

![](../images/python-logo.png)

# Basic usage

```python

import sys

a = "Python3"
print(f"Hello from {a} !")
print(f"value of a: {a}")
```


# Matplotlib example

```python
import numpy as np
import matplotlib.pyplot as plt
import matplotlib

matplotlib.rcParams['figure.dpi'] = 150
plt.style.use('dark_background')

plt.rcParams['text.usetex'] = True

data = [np.pi ** 2 / 6.0 - sum([1.0 / (i * i) for i in range(1, n)]) for n in range(1, 20)]
fig, ax = plt.subplots()
fig.patch.set_facecolor('#00000000')
ax.patch.set_facecolor('#00000000')
ax.set_xlabel(r'$N$')
ax.set_ylabel(r'$S_N$')
ax.set_title(r'$\displaystyle S_N \equiv \frac{\pi^2}{6} - \sum_{k=1}^{N} \frac{1}{k^2}$')
img = ax.plot(data, color = 'white')
img = ax.plot(data, 'o', color = 'white')
```


# Sympy example

```python
from sympy import symbols, latex
x, y = symbols('x y')
expr = x + 2*y**3
expr
```


```python
from IPython.display import display, Math
display(Math(r'$S_N \equiv \frac{\pi^2}{6} - \sum_{k=1}^{N} \frac{1}{k^2}$'))
```


```python
Math(r'$S_N \equiv \frac{\pi^2}{6} - \sum_{k=1}^{N} \frac{1}{k^2}$')
```


# Image loading with PIL

```python
%matplotlib inline
from PIL import Image

image = Image.open('images/python-logo.png')
image
```

# LaTeX example

```latex
%%latex

This is some text written in \LaTeX. Math expressions can also be used, as in the following:
\begin{equation}
S_N \equiv \frac{\pi^2}{6} - \sum_{k=1}^{N} \frac{1}{k^2}
\end{equation}
```


# Direct LaTeX example

> [!TODO]
> find a way to preview this !

$$
S_N \equiv \frac{\pi^2}{6} - \sum_{k=1}^{N} \frac{1}{k^2}
$$


