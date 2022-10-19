# Mobile_pendulum

## Dynamic System Simulation

First, a mathematical formulation of the problem is shown, as well as the hypotheses to be considered. A mathematical model of the system is made by means of the *Euler-Lagrange equations*, and it is solved using a numerical method. The numerical method proposed is from the three-stage Runge-Kutta family of methods.

## Lagrangian function of the dynamic system

$$ {\it L}=\frac{1}{2}\,m_{{1}}{{\it \dot{x}}}^{2}+\frac{1}{2}\,m_{{2}}{l}^{2}{d\varphi }^{2}
+m_{{2}}l\cos \left( \varphi  \right) d\varphi \,{\it \dot{x}}+\frac{1}{2}\,m_{{2}}
{{\it \dot{x}}}^{2}+m_{{2}}gl\cos \left( \varphi  \right) $$

## Euler-Lagrange equations

$$ \begin{align}
\stackrel{\cdot\cdot}{x}\cos {\varphi} - \stackrel{\cdot}{x}\stackrel{\cdot}{\varphi}\sin {\varphi} + l\stackrel{\cdot\cdot}{\varphi} &= -\stackrel{\cdot}{x}\stackrel{\cdot}{\varphi} \sin {\varphi} - g \,\sin {\varphi} \notag \\
\stackrel{\cdot\cdot}{x}\cos {\varphi} + l\stackrel{\cdot\cdot}{\varphi} + g \,\sin {\varphi} &= 0 
\end{align} $$
