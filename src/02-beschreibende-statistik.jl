### A Pluto.jl notebook ###
# v0.19.4

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 049ea5c2-b2e9-4524-965e-0db726134f1d
using DataFrames, CSV

# ╔═╡ ed832ad1-62f1-4ef6-a5d3-12e6bd2b60cd
using Plots

# ╔═╡ 22592e54-a24b-446d-bde0-93ec4c802b9b
using StatsBase
# Man muss im Folgenden das "StatsBase." nicht mit schreiben. Ich tue es hier, um deutlich zu machen, wo die Funktion her kommt

# ╔═╡ bedcae55-ad81-485a-872e-6cafb82bde86
using StatsPlots

# ╔═╡ f03912ab-9f15-46fb-87f9-b7f38d7c61e1
using Polynomials

# ╔═╡ 69726543-b247-44ce-b5e3-1672e9b5b3a1
using LsqFit

# ╔═╡ 2ee624de-2124-4f5e-82e6-46fd1c7dc62b
using PlutoUI,  LinearAlgebra

# ╔═╡ f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# DO NOT MODIFY, will be updated by update_navbar.jl
HTML("    <nav >\n    Vorbereitungen:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/index.html\"><em>Intro</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/software.html\"><em>Software</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/01-basic_syntax.html\"><em>Julia Basics</em></a> / \n\n<br>\nStatistik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/02-beschreibende-statistik.html\"><em>Beschreibende Statistik</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/03-wahrscheinlichkeit.html\"><em>Wahrscheinlichkeit</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/04-schaetzung.html\"><em>Schätzung</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/05-messunsicherheit.html\"><em>Messunsicherheit</em></a> / \n\n<br>\nFourier-Transformation:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/06-Fourier-Transformation.html\"><em>Fourier-Transformation</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/07-Frequenzraum.html\"><em>Frequenzraum</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/08-Filter.html\"><em>Filter</em></a> / \n\n<br>\nMesstechnik:\n\n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/09-Rauschen.html\"><em>Rauschen</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/10-Detektoren.html\"><em>Detektoren</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/11-Lock-In.html\"><em>Lock-In-Verstärker</em></a> / \n<a class=\"sidebar-nav-item\" href=\"https://pluto.ep3.uni-bayreuth.de/teca/12-heterodyn.html\"><em>Heterodyn-Detektion</em></a> / \n\n<br>\n\n\n    </nav>\n\t")

# ╔═╡ c58f76d9-45e8-4d72-9bce-f69321ee64d4
html"""<div>
<font size="7"><b>2 Beschreibende Statistik</b></font> </div>

<div><font size="5"> Markus Lippitz </font> </div>
<div><font size="5"> 2. Mai 2022 </font> </div>
"""

# ╔═╡ f4be8945-c54d-4162-8ee1-2fe3cfb078f1
md"""
**Ziele** Sie können Methoden der beschreibenden Statistik
*anwenden* und in Julia *implementieren*, um Aussagen über
Datensätze zu treffen.

-   Mittelwert und Standardabweichung

-   Momente

-   Korrelation und Kovarianz

**Literatur**  Stahel Kap. 2 & 3, Bevington Kap. 1
"""

# ╔═╡ dad2a7b0-f900-4a77-b7a3-b2b49d38ce14
md"""
# Überblick

Durch eine *Messung* erhalten wir uns einen Messwert einer physikalischen Größe. Wir können die Messung bei ansonsten unveränderten Bedingungen wiederholen und erhalten viele Messwerte, die nur im idealisierten Fall identisch sind. Diese Menge von Messwerten wird in der Statistik *Stichprobe* genannt. In diesem Kapitel versuchen wir zunächst, Aussagen über diese Stichprobe zu machen. Eigentlich wollen wir aber natürlich etwas über die Wirklichkeit sagen können. Der Schluss von den Messwerten auf die  Natur wird in der Statistik *Schätzung* genannt. Das ist dann Inhalt eines späteren Kapitels.

"""

# ╔═╡ 8cd8d8ea-5ece-4eec-8e46-13a52aed1d3a
md"""
# Temperaturverlauf

Als konkretes Beispiel betrachten wir den Temperaturverlauf am 1. August 2021 in einem unserer (klimatisierten) Labore. In einer idealen Welt wäre die Temperatur genau $21^\circ$C, aber natürlich ändert sie sich im Laufe des Tages. Diese Zeitabhängigkeit ignorieren wir zunächst und betrachten dies als wiederholte Messung bei unveränderten Bedingungen. 
"""

# ╔═╡ dcba4d9e-89d9-4fac-820a-fb24da9b1916
md"""
Zunächst laden wir den Datensatz. Hilfreich sind dabei die Pakete DataFrames und CSV.
"""

# ╔═╡ 52f64c20-a045-4ee6-a307-f50af60eae49
md"""
Dann laden wir die Datei in die Variable 'datensatz'. Die Spalten sind durch ein Tab ('\t') getrennt und die ersten 4 Zeilen beinhalten einen Datumsstempel, der uns hier nicht interessiert.
"""

# ╔═╡ 1868cca5-3cfb-4376-8468-d13831366cc9
datensatz = CSV.read(download("https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/02-beschreibende-statistik/Temperatur_1_0_05_1_Tag_210801.dat"), DataFrame; delim='\t', header=5)

# ╔═╡ 436b8f12-d833-42ec-b85c-31eb96ad862a
md"""
Unsere Stichprobe sei die Ist-Temperatur
"""

# ╔═╡ 70e91e6e-864a-4e9a-ab7d-c592833c1f59
stichprobe = datensatz.Tist

# ╔═╡ 9ec97d94-274a-43e0-ae46-aa89d6149f0b
md"""
# Grafische Darstellung

Typischerweise ist es nicht sehr sinnvoll, alle Werte der Stichprobe in der Reihenfolge ihrer Messung darzustellen. Hier tun wir es trotzdem. 
"""

# ╔═╡ 88143e8d-1a08-4aca-9f42-63c39c8ec0e9
md"""
Wir benutzen hier die Plots-Bibliothek und das interaktive plotly-backend
"""

# ╔═╡ db816800-beb8-417b-a1dd-eab6b6939eb8
plotly();

# ╔═╡ d2ec129a-e27e-46fe-a066-6883cab53aab
plot(stichprobe, xlabel="Laufende Nummer des Messung", ylabel="T_ist (deg C)", legend=false)

# ╔═╡ 1213593e-89dc-44a7-94e9-9868bd08c715
md"""
Auf den ersten Blick funktioniert die Klimaanlage ganz gut. Es ist keine systematische Variation zu erkennen.
"""

# ╔═╡ fe5d30f7-74f8-4b4b-b604-ee2d30fe8f33
md"""
## Histogramm

Relevanter ist die Darstellung der Stichprobe als Histogramm. Man zählt, wie oft ein Wert innerhalb eines Intervalls, einer _Klasse_, vorkommt und zeichnet Balken entsprechender Höhe und Breite.
"""

# ╔═╡ 10c78be3-c1a3-4808-b136-189ddba7e53f
Plots.histogram(stichprobe, xlabel="T_ist (deg C)", ylabel="Anzahl", legend=false)

# ╔═╡ 23509c7d-9e69-4f25-9839-ea9785cb7b75
md"""
Da scheint eine gewisse Präferenz für Temperaturen im Abstand von ca. 0.02 Grad zu sein, wo immer das herkommt.
"""

# ╔═╡ dc930a35-3705-40bd-9832-b13b084da3f1
md"""
Wichtig ist bei Histogrammen, dass das Integral über die x-Achse die Gesamtzahl der Messwerte bzw. eine Wahrscheinlichkeit von 1 ergibt. Das wird insbesondere dann relevant, wenn man unterschiedlich breite Klassen kombinieren möchte, weil beispielsweise am Rand nur wenige Ereignisse sind. Effektiv löst man dabei die Grenze zwischen den Klassen auf. Der neue Balken hat den Mittelwert der alten als Höhe, nicht seine Summe!

Das ist allerdings für die Histogramm-Funktion aus 'Plots' zu kompliziert. Wir benutzten 'StatsBase'.
"""

# ╔═╡ 51626ee2-e509-4cae-9f0e-1cf448b5b5e0
@bind left_bin_width  Slider( 0.005: 0.005 : 0.1; default= 0.02, show_value = true)

# ╔═╡ dbc3c042-3bb8-492c-810a-a3caf45ff794
@bind histo_mode Radio(["pdf", "density", "probability", "none"], default="none")

# ╔═╡ 532ab0aa-bc85-49b7-a577-124109ab53a1
let
	# Histogram with variable bin size on left half
	bins_l = range(20.88, 21; step=left_bin_width)
	bins_r = range(21, 21.1; step=0.005)
	h1 = StatsBase.fit(Histogram, stichprobe, [bins_l; bins_r])
	h1 = LinearAlgebra.normalize(h1,mode=Symbol(histo_mode))

	# for comparison: histogram with fixed, small bin size
	h2 = StatsBase.fit(Histogram, stichprobe, range(20.88, 21.1; step=0.005))
	h2 = LinearAlgebra.normalize(h2,mode=Symbol(histo_mode))

	# adjust label according to normalization
	yaxis =  Dict([ (:none, "Anzahl"), 
					(:pdf, "WK-Dichte (1/deg C)"), 
					(:probability, "Wahrscheinlichkeit"), 
					(:density, "Anzahl (1/deg C)")] )

	# overlay both histograms
	plot(h2, legend=false )
	plot!(h1, fillopacity=0.7, xlabel="T_ist (deg C)", 
			ylabel=yaxis[Symbol(histo_mode)])
end

# ╔═╡ 1f7dc3da-ab8d-4bc5-8bba-ee1d82d6b7a4
md"""
### Histogramme selbst gemacht
"""

# ╔═╡ 975e9fa8-d627-40a7-96ec-206b7e4809c7
let
	binsize = 0.005
	edges = range(20.9, 21.1; step=binsize)
	counts = zeros(length(edges))
	
	for id = 1:length(edges)-1
		edge_low = edges[id]
		edge_high = edges[id+1]
		counts[id] = count(x -> edge_low <= x <edge_high , stichprobe)
	end
	
	bar(edges .+ binsize/2, counts, 
		xlabel="T_ist (deg C)", ylabel="Anzahl", legend=false)
end

# ╔═╡ 610cd280-d3b8-47c9-ad6e-4fb1577a6c4c
md"""
# Rang und kumulative Verteilungsfunktion
"""

# ╔═╡ 00ec87d6-4b4d-42d7-a315-885ef16649a6
md"""
Unsere Stichprobe besteht aus den Werten $x_i$ mit dem laufenden Index $i = 1 \dots n$. Wir können die $x_i$ der Größe nach sortieren und bezeichnen dann mit $x_{[i]}$ den $i$-ten Eintrag nach Sortierung. Also ist $x_{[1]}$ die kleinste Zahl und $x_{[n]}$ die größte.
"""

# ╔═╡ 3980b93b-dca5-41e8-9db5-b9ec5bb06b86
md"""
In Julia ist die zuerst gemessene Zahl
"""

# ╔═╡ 447f26d1-41f1-4fe1-aa5c-004ec9d18a36
stichprobe[1]

# ╔═╡ 0a755560-a580-41f2-9327-724882fb154f
md"""
und die letzte Zahl ist
"""

# ╔═╡ c7d415fc-9564-4f8b-b503-ae09f9d17bb9
stichprobe[end]

# ╔═╡ cdcd6224-6964-4774-a941-ff67c65d0568
md"""
Die drittletzte ist
"""

# ╔═╡ 3b5ce183-9dc1-452f-aa7c-d1f35ad6614f
stichprobe[end-2]

# ╔═╡ c21b3673-2c16-4e28-b155-9e9ec54ca84f
md"""
Wir können die Stichprobe sortieren und direkt auf die sortierte Liste zugreifen, zB die zweitgrößte Zahl ist
"""

# ╔═╡ fded84d1-cb5b-4b51-940c-3772594e3aeb
sort(stichprobe)[end-1]

# ╔═╡ f20230a5-2fe9-4907-b5e4-13a98482eb56
md"""
Der **Rang** (engl. rank) einer Zahl gibt an, wie wievielt-kleinste Zahl sie ist. Das schreibt man als $\text{Rang}(x_i)$. 
Es gibt [verschiedene Methoden](https://en.wikipedia.org/wiki/Ranking#Strategies_for_assigning_rankings) damit umzugehen, dass ein Wert mehrfach vorkommt.

"""

# ╔═╡ 25b6f838-a496-4b4e-a456-478d4eb1b536
x = [3.4, 6.1, 1.2, 7.8, 3.4];

# ╔═╡ 98330947-bb95-4f2e-a380-991891a3328b
md"""
Man ignoriert einfach, dass manche Zahlen doppelt vorkommen
"""

# ╔═╡ 84dc49a5-642f-42d1-8520-a1f338991531
StatsBase.ordinalrank(x)

# ╔═╡ cb609ac3-0e0c-4db2-abb3-528371c46c46
md"""
oder wie bei Olympia
"""

# ╔═╡ 7e8bf5e0-284e-478c-89e1-08ffee174e13
StatsBase.competerank(x)

# ╔═╡ 51c2555f-7040-4f56-840c-5e9462561d31
md"""
Oft erhalten alle identischen Zahlen den gleichen Rang, und zwar den Mittelwert der von ihnen belegten Ränge.
"""

# ╔═╡ 12a9d1d8-a5ca-4500-a804-183821a9d026
StatsBase.tiedrank(x)

# ╔═╡ 73c659cb-22df-460b-97ea-ddccb2ebb1bb
md"""
Die **empirische kumulative Verteilungsfunktion** (engl. empirical cumulative distribution function, ecdf) ordnet jedem Wert $x$  den  Anteil der Wert $x_i$ zu, die kleiner oder gleich $x$ sind. 
```math
 F(x) = \frac{1}{n} \, \text{Anzahl} \, \left(i | x_i \le x \right)
```
Der Graph dieser Funktion $F(x)$ zeigt Stufen mit Ecken an den Koordinaten $(x_{[k]}, (k-1)/n)$ und  $(x_{[k]}, k/n)$.
"""

# ╔═╡ eff8db42-396e-4570-8244-6c5cadd7d92e
md"""
In Julia erzeugt 'ecdf' eine Funktion, wie wir aufrufen können.
"""

# ╔═╡ b19f652c-ec11-457d-8566-3aa53d3f6c71
ecdf_x = StatsBase.ecdf(x);

# ╔═╡ 284bb169-bdaf-416a-8f5d-7fd53689913d
let
	u = range(0, 10; step=0.001)
	plot(u, ecdf_x(u), xlabel="x", ylabel="F(x)", legend=false)
	# zum Vergleich 'von Hand'
	scatter!(sort(x),  (1:length(x)) / length(x))
	scatter!(sort(x), ((1:length(x)) .- 1) / length(x))
end

# ╔═╡ 5ae473fc-320d-4b75-8052-311fc074b5d9
md"""
Für die Labortemperatur ist dies
"""

# ╔═╡ c3284711-b881-496d-b9ad-68d4865d60d2
let
	u = range(20.88, 21.12; step=0.0001)
	plot(u, StatsBase.ecdf(stichprobe)(u), xlabel="Temperatur T (deg C)", ylabel="F(T)", legend=false)
end

# ╔═╡ ba05d98f-605f-4c2f-a4bd-be91af6d60c8
md"""
# Kennzahlen 

Mit einigen Kennzahlen können wir die Stichprobe beschreiben. Die bekannteste ist sicherlich der **Mittelwert** (engl. mean), Durchschnitt oder Schwerpunkt
```math
\bar{x} = \frac{1}{n} \sum_{i=1}^{n} x_i
```
"""

# ╔═╡ a5e5dfb3-81cc-4365-8036-c5b6444df798
md"""
In Julia ist das
"""

# ╔═╡ d17a2490-23a1-43ca-bf93-a26f08e8dbd5
StatsBase.mean(stichprobe)

# ╔═╡ 7df3ac3b-f6cd-4a43-9803-7cff9d544332
md"""
oder
"""

# ╔═╡ f44f734c-4e33-4e3d-992c-d212e3925832
sum(stichprobe) / length(stichprobe)

# ╔═╡ 7108dfab-f3f0-4c83-ba59-e5cb7307418c
md"""
Manchmal ist der **Median** oder Zentralwert aussagekräftiger. Das ist der mittlere Wert einer geordneten Stichprobe, also 
```math
\text{med}_i \left< x_i \right> = x_{[ (n+1)/2]} \quad \text{bzw.} \quad =\frac{1}{2} \left( x_{[n/2]} +  x_{[(n/2) +1]} \right)
```
Der Median ist weniger anfällig gegen Ausreißer. Selbst wenn man den größten Wert der Stichprobe mit 100 multipliziert, ändert sich der Median nicht, der Mittelwert aber schon.
"""

# ╔═╡ 606efab3-a405-4cd5-a717-901a966da04c
md"""
In Julia
"""

# ╔═╡ cb17d0e7-3e69-4279-83c8-15e5a92815c2
StatsBase.median(stichprobe)

# ╔═╡ ebe77f7a-b85b-409d-b57c-786354a385bc
md"""
oder 'von Hand'. Die Division liefert einen Fließkomma-Zahl, die erst in ein Integrer gewandelt werden muss, bevor sie als Index verwendet werden kann.
"""

# ╔═╡ 50779ec0-0cc2-420d-9337-89240cd31548
sort(stichprobe)[Int32(length(stichprobe)/2)]

# ╔═╡ e249afb3-2028-4b9e-828b-e757f2f27ee4
md"""
Analog zum Median kann man die sortierte Stichprobe an anderen Stellen als der Mitte auslesen. Das untere bzw. obere  **Quartil**  liest den Wert bei $1/4$ bzw. $3/4$. **Perzentile** lesen bei $p$ Prozent aus. Allgemein nennt man diese Maße [Quantile](https://de.wikipedia.org/wiki/Empirisches_Quantil).
"""

# ╔═╡ 11d40f7a-2c4c-4d64-843e-50824e19d10b
md"""
Das 2%-Perzentil unseres Datensatzes ist
"""

# ╔═╡ 11394695-2a1c-4192-be2f-32a5250d0edc
StatsBase.percentile(stichprobe, 2)

# ╔═╡ 29959a13-a44b-49c9-86a1-c54c64403ebd
md"""
Die Quartilen sind 
"""

# ╔═╡ df8a3bc3-3980-4522-8a19-ee7264ea442e
StatsBase.nquantile(stichprobe, 4)

# ╔═╡ 0f017280-7a66-49f3-81a7-70dcba51a6a7
md"""
wobei die beiden 'äußeren' Werte das Minimum und das Maximum des Datensatzes angeben
"""

# ╔═╡ cd7b6262-004e-47bc-bacc-c23088a154b9
minimum(stichprobe), maximum(stichprobe)

# ╔═╡ a45c2888-98fe-42fc-b9ca-f307efb6831f
md"""
Die **Varianz** ist ein Maß für die Streuung der Datenpunkte
```math
\text{var} = \frac{1}{n-1} \sum_{i=1}^n \, (x_i - \bar{x})^2 = 
\frac{1}{n-1} \left[ \sum_{i=1}^n x_i^2 -\frac{1}{n} \left( \sum_{i=1}^n x_i \right) ^2 \right]
```
Die **Standardabweichung** ist die Wurzel der Varianz
```math
 \sigma = \sqrt{\text{var}} = \sqrt{\frac{1}{n-1} \sum_{i=1}^n \, (x_i - \bar{x})^2}
```
Man beachte den Term $n-1$ in dieser Definition. Es gibt eine sehr ähnliche Definition mit $n$ an Stelle von $n-1$, nur dass dann auch $\bar{x}$ durch $\mu$ ersetzt ist. Doch dazu mehr in dem Kapitel über Schätzer.
"""

# ╔═╡ f6fc5b01-6ea3-411f-bf12-878a4638bc01
md"""
In Julia 'von Hand' ist die Standardabweichung unsere Stichprobe
"""

# ╔═╡ 22e24d5a-5f53-4c38-ab48-fe3de8589057
sqrt(sum( (stichprobe .- mean(stichprobe)).^2) / (length(stichprobe)-1))

# ╔═╡ 8a0f6def-dfb6-4aca-a440-dfda31dd232c
md"""
Es geht auch mit der 'eingebauten' Funktion 'std'. Durch 'corrected' kann man zwischen der Variante $n-1$ (true) und $n$ (false) umschalten.
"""

# ╔═╡ d50a9c8b-08d8-4fcf-a2da-0c1cb0ff4021
std([1,2,3], corrected=false), sqrt(2/3) , std([1,2,3], corrected=true)

# ╔═╡ fa6d85be-0f22-438b-99b0-ec714ef2b514
md"""
oder aus 'StatsBase' Mittelwert und Standardabweichung in einem Aufwasch
"""

# ╔═╡ 9a681882-c8bd-4c99-979e-ca632e37e173
StatsBase.mean_and_std( [1,2,3], corrected=true)

# ╔═╡ b6921ce5-7144-484b-96e0-5276eb244b36
md"""
Man kann die Definition der Varianz ausbauen zu  allgemeinen **statistischen Momenten**. Das dritte Moment ist die **Schiefe** (engl. skewness) 
```math
\frac{1}{n} \sum \left( \frac{x_i - \bar{x}}{\sigma} \right)^3
```
und das vierte die  **Wölbung** (engl. kurtosis)
```math
\frac{1}{n} \sum \left( \frac{x_i - \bar{x}}{\sigma} \right)^4
```
Durch die Division durch die Standardabweichung sind diese Momente einheitenfrei.
"""

# ╔═╡ d879445f-3379-4b82-8fbe-05354de4b7a7
md"""
In Julia
"""

# ╔═╡ e2018d1a-52ed-427b-9f1b-d6c50a1f18a5
StatsBase.skewness(stichprobe), StatsBase.kurtosis(stichprobe)

# ╔═╡ fcdde392-2566-4d03-a759-b736f5a26455
md"""
## Kennzahlen klassierter Daten
"""

# ╔═╡ cc65205c-776a-4dbb-b8d3-625d268a24ef
md"""
Schon beim Histogramm hatten wir Daten in Klassen eingeteilt. Alle Messwerte, die in ein gewisses Temperatur-Intervall gefallen sind, zählten zum gleichen Balken des Histogramms. Manchmal möchte man solche klassierte Daten weiter verarbeiten, manchmal liegen Daten auch direkt nur klassiert vor. Ein Beispiel ist die Notenverteilung einer Klausur. Die Noten können dabei nur wenige verschiedene Werte annehmen.
"""

# ╔═╡ be18fc94-6a7a-4959-8f02-9bc118969d18
md"""
Auch aus klassierten Daten kann man die oben besprochenen Kennzahlen berechnen. Sei $c_l$ die Grenze der Klassen, und somit $z_l = (c_{l-1} + c_l) /2$ die Mitten der Klassen. Beim Übergang zu klassierten Daten ersetzt man in den Gleichen oben jedes $x_i$ durch 'seine' Klassenmitte $z_{l(i)}$, summiert also weiterhin über $i$. Dabei sind dann natürlich viele $z_{l(i)}$ identisch, so dass man diese Teilsummen ausklammern kann und durch die Anzahl $h_l$ der Werte in der Klasse $l$ ersetzen kann.
"""

# ╔═╡ 07e79d80-b780-44e2-869a-5e97bcd075c1
md"""
Ausgeschrieben ergibt sich für den **Mittelwert**
```math
\bar{x} \approx \frac{1}{n} \sum_l h_l z_l
```
und die **Varianz**
```math
\text{var} \approx \frac{1}{n-1} \sum_l h_l (z_l - \bar{x})^2 = 
\frac{1}{n-1} \left( \sum_l h_l z_l^2  - n\bar{x}^2 \right) 
```
weil $\sum_l h_l = n$.
"""

# ╔═╡ ed6f00d8-9ade-47ca-86f6-7018f40426a2
md"""
# Boxplot

Wenn man verschiedene Stichproben auf einen Blick vergleichen will, dann ist der 'boxplot' hilfreich. Er zeichnet eine Kiste vom  oberen zum unteren Quartil mit einem Strich beim Median. Die 'Fehlerbalken' haben typischerweise die Länge von 1.5 mal der Kistenhöhe, werden aber zum nächstgelegenen Wert nach 'innen' gerundet. Alle weiter außen liegenden Werte werden eingezeichnet.
"""

# ╔═╡ 816438b7-4fc0-4581-a7a0-b375ec4e88be
 StatsPlots.boxplot(datensatz.Tist, ylabel = "Temperatur (deg. C)", legend=false, xaxis=false)

# ╔═╡ 59832eb9-b4fa-4a5b-97a0-d96f532e82cc
md"""
So kann man gut mehrere Verteilungen vergleichen.
"""

# ╔═╡ 4de3b412-3ad3-448b-8f38-ea6ca09ce337
StatsPlots.boxplot([ datensatz.Tist, datensatz.Kuelhlluft,  datensatz.Zuluft], ylabel = "Temperatur (deg. C)",  xticks = (1:3, ["T ist", "Kühlluft", "Zuluft"]), legend=false)

# ╔═╡ 0e889909-9ded-438f-bdd5-4989eb6cdddf
md"""
# Mehrdimensionale Daten
"""

# ╔═╡ af438416-7d6f-44b3-980e-cd6823688008
md"""
Oft werden mit einer Beobachtung, einer Messung mehrere Größen gemessen. Damit erhält man mehrdimensionale oder multivariate Daten.

Im Prinzip war schon unser Temperatur-Beispiel von oben mehrdimensional, da wir zu jedem Zeitpunkt nicht nur die Raumtemperatur, sondern auch Temperaturen an anderen Stellen vorliegen hatten. Die hatten wir bisher ignoriert. Nun nehmen wir sie hinzu, und auch noch die gleichzeitige Messung der gleichen Größen in anderen Räumen.
"""

# ╔═╡ 64fe649e-9b17-451f-8d3f-7112514bb7fe
md"""
Wir laden vier Dateien in eine gemeinsame Variable
"""

# ╔═╡ 11affb9f-2d9a-47a4-9cb1-2e6ead3de727
begin 
	räume = ["1_0_05_1","1_0_05_3","2_0_08","3_0_07"]
	files = ["https://raw.githubusercontent.com/MarkusLippitz/teca/main/res/02-beschreibende-statistik/Temperatur_$(r)_Tag_210801.dat" for r in räume]
	datensätze = CSV.read.(download.(files), DataFrame; delim='\t', header=5)
	# man beachte den Punkt in "read.(download" und den in "download.(files" !
	# -> Wende alles auf alle Eintröge in "räume" an
end;

# ╔═╡ aa04f999-0979-47a3-8694-7de7df4ebf21
md"""
Zunächst stellen wir wieder die Daten als Funktion der Zeit dar. Die erste Ziffer der Raumnummer bezeichnet das Gebäudeteil im BGI. In Bauteil 1 scheint die Zuluft im Sommer merklich warm zu werden, in den Bauteilen 2 und 3 nicht.
"""

# ╔═╡ 8997748b-bcd3-44e6-aecb-e003a3ed0a12
begin
	plot()  # generate empty plot
	for i in 1:length(räume) # plot 4 traces on top of each other
	   plot!(datensätze[i].Time, datensätze[i].Zuluft, label=räume[i]) 
	end
	plot!() # show last plot
end

# ╔═╡ 6becffb6-1810-4c21-8d81-28cb2021cdfe
md"""
In einem **Streudiagramm** stellt man eine Größe gegenüber der anderen dar, um so Zusammenhänge zu erkennen. Wenn die Punkte sehr dicht liegen reduziert das die Aussagekraft. Hier ist einfach nur jeder 50. Datenpunkt gezeichnet.
"""

# ╔═╡ 30c6734d-4aad-4065-8604-7e3d91fa59fb
let
	dec = 50
	plot([20.9, 23.8], [20.9, 23.8], label="Diagonale")
	Plots.scatter!(datensätze[1].Zuluft[1:dec:end], datensätze[2].Zuluft[1:dec:end], 
		label="1 vs 2",  markersize=2, markerstrokewidth=0)
	Plots.scatter!(datensätze[3].Zuluft[1:dec:end], datensätze[4].Zuluft[1:dec:end],  
		label="3 vs 4",markersize=2, markerstrokewidth=0, 
		xlabel="Zuluft A", ylabel="Zuluft B",aspect_ratio=:equal,)
end

# ╔═╡ a844007c-4e7d-4c47-b7e8-4ae39e9c0f02
md"""
Alternativ kann man ein zweidimensionales Histogramm zeichnen, und die Anzahl pro bin farbkodieren.
"""

# ╔═╡ e908d5e3-563b-4982-8e5b-5e642bb62ef0
Plots.histogram2d(datensätze[3].Zuluft, datensätze[4].Zuluft, bins=100,aspect_ratio=:equal, xlabel="Zuluft 3", ylabel="Zuluft 4", colorbar_title="Anzahl")

# ╔═╡ 2b1f9027-176f-46f9-981e-387042dddb2b
md"""
# Produktmomenten-Korrelation
"""

# ╔═╡ f5d85c34-d26d-4e72-b64d-5baa966555db
md"""
Eine Kennzahl für den Zusammenhang zwischen zwei Messgrößen ist die *Korrelation*, von der es verschiedene Varianten gibt.
"""

# ╔═╡ 39dd4490-fbce-43c2-b216-721e73613281
md"""
Zunächst normieren wir die einzelnen Messwerte so, dass deren Mittelwert 0 und deren Standardabweichung 1 beträgt. Wir definieren also
```math
\tilde{x}_i = \frac{x_i - \bar{x}}{\sigma_x}
```
und analog für die zweite Größe $y_i$. Wenn nun $\tilde{x}_i$ und $\tilde{y}_i$ beide gleichzeitig positiv, oder beide gleichzeitig negativ sind, dann entspricht dies einem gewissen positiven Zusammenhang zwischen $x_i$ und $y_i$. Ein einfaches Maß für diesen Zusammenhang ist das Produkt $\tilde{x}_i \tilde{y}_i$, also 
```math
r_{xy} = \frac{1}{n-1} \sum_i \tilde{x}_i \tilde{y}_i
```

"""

# ╔═╡ 5799aa7b-ef1c-430e-8739-b755c6e743ad
md"""
Dies ist die (einfache) **Korrelation**, oder  auch *Produktmomenten-Korrelation nach Pearson*. Wir können das noch etwas umformen
```math
r_{xy} = \frac{\text{var}_{xy}}{\sigma_x \sigma_y} \quad \text{mit} \quad  \text{var}_{xy} = \frac{1}{n-1} \sum_i (x_i - \bar{x})(y_i - \bar{y})
```
Die Kovarianz $\text{var}_{xy}$  ist sehr analog zur Varianz, nur das das Quadrat einer Größe durch das Produkt von zwei Größen ersetzt wird.
"""

# ╔═╡ b68d6412-2656-43f3-a393-10e325b35d24
md"""
Einfache Spezialfälle sind $x_i = y_i$, was $r_{xy} = 1$ ergibt. Falls ein linearer Zusammenhang besteht  in der Art $y_i = a + b x_i$, dann ist ebenfalls $r_{xy} = 1$, falls $b>0$, und $r_{xy} = -1$, falls $b<0$. Die Produktmomenten-Korrelation  misst also die Stärke des linearen Zusammenhangs.
"""

# ╔═╡ 510f698a-dee9-4e67-9ade-57289689f189
md"""
In Julia ist geht das via StatsBase
"""

# ╔═╡ f7d815df-8c7c-4994-9f4a-5d3697bac3ca
StatsBase.cor(datensätze[3].Zuluft, datensätze[4].Zuluft)

# ╔═╡ 7847ec0b-df92-4dd0-abe9-37dc8eae5b56
StatsBase.cor(datensätze[1].Zuluft, datensätze[2].Zuluft)

# ╔═╡ ab22c5f2-908e-4bbf-a67a-4b1157a10023
md"""
oder von Hand
"""

# ╔═╡ e7281c97-750b-473b-9860-e786a44e26a0
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	(m_x, σ_x) =  StatsBase.mean_and_std( x, corrected=true)
	(m_y, σ_y) =  StatsBase.mean_and_std( y, corrected=true)
	xt = (x .- m_x) ./ σ_x
	yt = (y .- m_y) ./ σ_y
	cor = sum( xt .* yt) / (length(xt)-1)
end

# ╔═╡ 80e3d9db-e6e9-4e64-9a28-123141079edb
md"""
**Achtung** Diese Produktmomenten-Korrelation misst nur die Stärke eines linearen Zusammenhangs. Es können noch andere Zusammenhänge höherer Ordnung vorhanden sein, die bei gleichem $r_{xy}$ sehr verschiedene Streudiagramme bewirken! Die Korrelation ist nicht robust gegen Ausreißer.
"""

# ╔═╡ 79810bad-ceb4-42a0-8b16-53f25004250b
md"""
# Rangkorrelation
"""

# ╔═╡ 7ca6a708-e123-406a-9987-ad52f9323224
md"""
Ähnlich zum Unterschied zwischen Mittelwert und Median, kann man auch eine Korrelation nicht zwischen den Werten an sich, sondern zwischen den Rängen berechnen. Hier spielen Ausreißer dann quais keine Rolle mehr.
"""

# ╔═╡ 58a063d6-6dd3-4e08-abe7-357e96d5eac9
md"""
Analog definieren wir die Spearmansche Rangkorrelation
```math
r_{xy}^\text{(Sp)} = \frac{\text{var}_\text{Rang(x) Rang(y)}}{\sigma_\text{Rang(x)} \sigma_\text{Rang(y)}} 
```
"""

# ╔═╡ eaff35b0-be07-495d-9aec-92f1f64a2b22
md"""
Der Mittelwert aller Ränge ist 
```math
\bar{\text{Rang}(x)}  = \frac{1 + 2 + \dots + n}{n} = \frac{n+1}{2}
```
Die Standardabweichung ist **XXX TODO** und die Kovarianz
```math
\text{var}_\text{Rang(x) Rang(y)} = \frac{1}{n-1} \sum_i \left( \text{Rang}(x_i) - \frac{n-1}{2} \right)\left( \text{Rang}(y_i) - \frac{n-1}{2} \right)
```
Zusammen ergibt das
```math
r_{xy}^\text{(Sp)} = 1 - \frac{6}{n(n^2 -1)} \sum_i ( \text{Rang}(x_i)  -  \text{Rang}(y_i) )^2
```
"""

# ╔═╡ c100060d-1a84-47a6-bcdd-0105e23190d9
md"""
In Julia ist das
"""

# ╔═╡ 288f3592-ab4c-434b-a882-5708959543ef
StatsBase.corspearman(datensätze[3].Zuluft, datensätze[4].Zuluft)

# ╔═╡ 47f61db3-26fe-4dee-9bc9-438434a94530
StatsBase.corspearman(datensätze[1].Zuluft, datensätze[2].Zuluft)

# ╔═╡ 8e1ad6b0-07ec-4d6d-baed-33046cb539dc
md"""
## Achtung

- Eine Korrelation ist keine Kausalität. Nur weil etwas korreliert ist, heißt das noch nicht, dass es einen interessanten Grund dafür gibt. Die Größe der Storchenpopulation in Deutschland ist sicherlich mit der Geburtenrate der letzten 50 Jahre korreliert.

- Korrelationen können auch entstehen, in dem man beide Größen $x$ und $y$ mit einer gemeinsamen Größe $z$ normiert. Dann ist ggf. $x/z$ mit $y/z$ korreliert, obwohl $x$ nicht mit $y$ korreliert ist.
"""

# ╔═╡ d6660328-b1af-4c1b-94d4-48c58858f166
md"""
# Lineare Regression
"""

# ╔═╡ 6715ac8c-207c-4ec1-8b8d-c7e7ff5d8a6c
md"""
Auch eine lineare Regression sucht nach einem linearen Zusammenhang zwischen $x_i$ und $y_i$. Der Unterschied liegt in der Interpretation der $x_i$. Bei der Korrelation waren die $x_i$ und die $y_i$ völlig gleichberechtigt. Es ist ja sogar $r_{xy} =  r_{yx}$. Bei einer linearen regression nimmt man die $x_i$ als 'unabhängige Variable' oder 'Ausgangsgröße' an. Diese Werte im Experiment vorgegeben, sind fest und fehlerfrei bekannt. Die $y_i$ sind die 'Zielgröße', der 'Messwert'. Die Aufgabe der linearen Regression ist es, aus bekanntem $x$ ein noch zu messendes $y$ vorherzusagen. B
"""

# ╔═╡ 99734a5a-f5f7-4168-9232-653802efaced
md"""
Bei der linearen Regression suchen wir die Parameter $(a,b)$ einer Funktion 
```math
f(x) = a + b x
```
so dass die Abweichung zwischen vorhergesagtem Wert $f(x_i)$ und gemessenen Wert $y_i$ möglichst klein wird. Dazu betrachten wir die *Residuen*
```math
\Delta_i (a,b) = y_i - (a + b x_i)
```

"""

# ╔═╡ 80a96166-c072-4e5f-991e-9400ae506959
md"""
Ein oft verwendetes Maß ist die Summe der Quadrate der Abweichungen (*Methode der kleinsten Quadrate*)
```math
Q(a,b) = \sum_i [\Delta_i(a,b)]^2
```
"""

# ╔═╡ a6d27afc-3984-4262-87e8-85eee8928560
md"""
Wir wollen $Q(a,b)$ minimieren, suchen also Nullstellen der Ableitungen nach $a$ und $b$. Man findet (siehe z.B. Stahel)
```math
b = r_{xy} \frac{\sigma_y}{\sigma_x} \quad \text{und} \quad a = \bar{y} - b \bar{x}
```
"""

# ╔═╡ 1270488f-b477-4385-86eb-46d4f5955d7f
md"""
Man erkennt den Zusammenhang zwischen Regression und Korrelation durch das Auftauchen von $r_{xy}$.
"""

# ╔═╡ 12fc470d-34cc-4ef2-9f56-cd3daf740818
md"""
In Julia geht das beispielsweise über das Anpassen eines Polynoms 1. Grades
"""

# ╔═╡ 5283eb9f-c65e-4aaa-aa2a-3e4624cce6f9
Polynomials.fit(datensätze[3].Zuluft, datensätze[4].Zuluft, 1)

# ╔═╡ dafcdb72-fbcd-4602-93f4-ed3df42ac060
md"""
oder 'von Hand'
"""

# ╔═╡ 00fd8596-437c-4a02-b6b1-d61c92931e3f
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	(m_x, σ_x) =  StatsBase.mean_and_std( x, corrected=true)
	(m_y, σ_y) =  StatsBase.mean_and_std( y, corrected=true)
	r_xy = StatsBase.cor(x,y)

	b = r_xy * σ_y  / σ_x
	a = m_y - b * m_x
	(a,b)
end

# ╔═╡ 4cc419da-89a8-4f12-b94c-881b4c1ba20e
md"""
Oder ganz allgemein über einen 'least square fit' (kleinste Quadrate [der Residuen])
"""

# ╔═╡ 1749f0c5-ae4b-47e7-8733-e719d1386933
let
	x = datensätze[3].Zuluft
	y = datensätze[4].Zuluft
	model(x, p) = p[1]  .+ p[2] .* x  # Zielfunktion
	p0 = [0.5, 0.5]  # Start-Parameter
	fit = LsqFit.curve_fit(model, x, y, p0)
	fit.param
end

# ╔═╡ d326a92d-23b2-43d4-b984-c51b9dd6a905
TableOfContents(title="Inhalt")

# ╔═╡ 00000000-0000-0000-0000-000000000001
PLUTO_PROJECT_TOML_CONTENTS = """
[deps]
CSV = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
DataFrames = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
LinearAlgebra = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"
LsqFit = "2fda8390-95c7-5789-9bda-21331edee243"
Plots = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
PlutoUI = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
Polynomials = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
StatsBase = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
StatsPlots = "f3b207a7-027a-5e70-b257-86293d7955fd"

[compat]
CSV = "~0.10.4"
DataFrames = "~1.3.2"
LsqFit = "~0.12.1"
Plots = "~1.27.5"
PlutoUI = "~0.7.38"
Polynomials = "~3.0.0"
StatsBase = "~0.33.16"
StatsPlots = "~0.14.33"
"""

# ╔═╡ 00000000-0000-0000-0000-000000000002
PLUTO_MANIFEST_TOML_CONTENTS = """
# This file is machine-generated - editing it directly is not advised

julia_version = "1.7.2"
manifest_format = "2.0"

[[deps.AbstractFFTs]]
deps = ["ChainRulesCore", "LinearAlgebra"]
git-tree-sha1 = "6f1d9bc1c08f9f4a8fa92e3ea3cb50153a1b40d4"
uuid = "621f4979-c628-5d54-868e-fcf4e3e8185c"
version = "1.1.0"

[[deps.AbstractPlutoDingetjes]]
deps = ["Pkg"]
git-tree-sha1 = "8eaf9f1b4921132a4cff3f36a1d9ba923b14a481"
uuid = "6e696c72-6542-2067-7265-42206c756150"
version = "1.1.4"

[[deps.Adapt]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "af92965fb30777147966f58acb05da51c5616b5f"
uuid = "79e6a3ab-5dfb-504d-930d-738a2a938a0e"
version = "3.3.3"

[[deps.ArgTools]]
uuid = "0dad84c5-d112-42e6-8d28-ef12dabb789f"

[[deps.Arpack]]
deps = ["Arpack_jll", "Libdl", "LinearAlgebra", "Logging"]
git-tree-sha1 = "91ca22c4b8437da89b030f08d71db55a379ce958"
uuid = "7d9fca2a-8960-54d3-9f78-7d1dccf2cb97"
version = "0.5.3"

[[deps.Arpack_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "OpenBLAS_jll", "Pkg"]
git-tree-sha1 = "5ba6c757e8feccf03a1554dfaf3e26b3cfc7fd5e"
uuid = "68821587-b530-5797-8361-c406ea357684"
version = "3.5.1+1"

[[deps.ArrayInterface]]
deps = ["Compat", "IfElse", "LinearAlgebra", "Requires", "SparseArrays", "Static"]
git-tree-sha1 = "c933ce606f6535a7c7b98e1d86d5d1014f730596"
uuid = "4fba245c-0d91-5ea0-9b3e-6abc04ee57a9"
version = "5.0.7"

[[deps.Artifacts]]
uuid = "56f22d72-fd6d-98f1-02f0-08ddc0907c33"

[[deps.AxisAlgorithms]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "WoodburyMatrices"]
git-tree-sha1 = "66771c8d21c8ff5e3a93379480a2307ac36863f7"
uuid = "13072b0f-2c55-5437-9ae7-d433b7a33950"
version = "1.0.1"

[[deps.Base64]]
uuid = "2a0f44e3-6c83-55bd-87e4-b1978d98bd5f"

[[deps.Bzip2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "19a35467a82e236ff51bc17a3a44b69ef35185a2"
uuid = "6e34b625-4abd-537c-b88f-471c36dfa7a0"
version = "1.0.8+0"

[[deps.CSV]]
deps = ["CodecZlib", "Dates", "FilePathsBase", "InlineStrings", "Mmap", "Parsers", "PooledArrays", "SentinelArrays", "Tables", "Unicode", "WeakRefStrings"]
git-tree-sha1 = "873fb188a4b9d76549b81465b1f75c82aaf59238"
uuid = "336ed68f-0bac-5ca0-87d4-7b16caf5d00b"
version = "0.10.4"

[[deps.Cairo_jll]]
deps = ["Artifacts", "Bzip2_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "JLLWrappers", "LZO_jll", "Libdl", "Pixman_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "4b859a208b2397a7a623a03449e4636bdb17bcf2"
uuid = "83423d85-b0ee-5818-9007-b63ccbeb887a"
version = "1.16.1+1"

[[deps.Calculus]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "f641eb0a4f00c343bbc32346e1217b86f3ce9dad"
uuid = "49dc2e85-a5d0-5ad3-a950-438e2897f1b9"
version = "0.5.1"

[[deps.ChainRulesCore]]
deps = ["Compat", "LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "9950387274246d08af38f6eef8cb5480862a435f"
uuid = "d360d2e6-b24c-11e9-a2a3-2a2ae2dbcce4"
version = "1.14.0"

[[deps.ChangesOfVariables]]
deps = ["ChainRulesCore", "LinearAlgebra", "Test"]
git-tree-sha1 = "bf98fa45a0a4cee295de98d4c1462be26345b9a1"
uuid = "9e997f8a-9a97-42d5-a9f1-ce6bfc15e2c0"
version = "0.1.2"

[[deps.Clustering]]
deps = ["Distances", "LinearAlgebra", "NearestNeighbors", "Printf", "SparseArrays", "Statistics", "StatsBase"]
git-tree-sha1 = "75479b7df4167267d75294d14b58244695beb2ac"
uuid = "aaaa29a8-35af-508c-8bc3-b662a17a0fe5"
version = "0.14.2"

[[deps.CodecZlib]]
deps = ["TranscodingStreams", "Zlib_jll"]
git-tree-sha1 = "ded953804d019afa9a3f98981d99b33e3db7b6da"
uuid = "944b1d66-785c-5afd-91f1-9de20f533193"
version = "0.7.0"

[[deps.ColorSchemes]]
deps = ["ColorTypes", "Colors", "FixedPointNumbers", "Random"]
git-tree-sha1 = "12fc73e5e0af68ad3137b886e3f7c1eacfca2640"
uuid = "35d6a980-a343-548e-a6ea-1d62b119f2f4"
version = "3.17.1"

[[deps.ColorTypes]]
deps = ["FixedPointNumbers", "Random"]
git-tree-sha1 = "024fe24d83e4a5bf5fc80501a314ce0d1aa35597"
uuid = "3da002f7-5984-5a60-b8a6-cbb66c0b333f"
version = "0.11.0"

[[deps.Colors]]
deps = ["ColorTypes", "FixedPointNumbers", "Reexport"]
git-tree-sha1 = "417b0ed7b8b838aa6ca0a87aadf1bb9eb111ce40"
uuid = "5ae59095-9a9b-59fe-a467-6f913c188581"
version = "0.12.8"

[[deps.CommonSubexpressions]]
deps = ["MacroTools", "Test"]
git-tree-sha1 = "7b8a93dba8af7e3b42fecabf646260105ac373f7"
uuid = "bbf7d656-a473-5ed7-a52c-81e309532950"
version = "0.3.0"

[[deps.Compat]]
deps = ["Base64", "Dates", "DelimitedFiles", "Distributed", "InteractiveUtils", "LibGit2", "Libdl", "LinearAlgebra", "Markdown", "Mmap", "Pkg", "Printf", "REPL", "Random", "SHA", "Serialization", "SharedArrays", "Sockets", "SparseArrays", "Statistics", "Test", "UUIDs", "Unicode"]
git-tree-sha1 = "96b0bc6c52df76506efc8a441c6cf1adcb1babc4"
uuid = "34da2185-b29b-5c13-b0c7-acf172513d20"
version = "3.42.0"

[[deps.CompilerSupportLibraries_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "e66e0078-7015-5450-92f7-15fbd957f2ae"

[[deps.Contour]]
deps = ["StaticArrays"]
git-tree-sha1 = "9f02045d934dc030edad45944ea80dbd1f0ebea7"
uuid = "d38c429a-6771-53c6-b99e-75d170b6e991"
version = "0.5.7"

[[deps.Crayons]]
git-tree-sha1 = "249fe38abf76d48563e2f4556bebd215aa317e15"
uuid = "a8cc5b0e-0ffa-5ad4-8c14-923d3ee1735f"
version = "4.1.1"

[[deps.DataAPI]]
git-tree-sha1 = "cc70b17275652eb47bc9e5f81635981f13cea5c8"
uuid = "9a962f9c-6df0-11e9-0e5d-c546b8b5ee8a"
version = "1.9.0"

[[deps.DataFrames]]
deps = ["Compat", "DataAPI", "Future", "InvertedIndices", "IteratorInterfaceExtensions", "LinearAlgebra", "Markdown", "Missings", "PooledArrays", "PrettyTables", "Printf", "REPL", "Reexport", "SortingAlgorithms", "Statistics", "TableTraits", "Tables", "Unicode"]
git-tree-sha1 = "ae02104e835f219b8930c7664b8012c93475c340"
uuid = "a93c6f00-e57d-5684-b7b6-d8193f3e46c0"
version = "1.3.2"

[[deps.DataStructures]]
deps = ["Compat", "InteractiveUtils", "OrderedCollections"]
git-tree-sha1 = "3daef5523dd2e769dad2365274f760ff5f282c7d"
uuid = "864edb3b-99cc-5e75-8d2d-829cb0a9cfe8"
version = "0.18.11"

[[deps.DataValueInterfaces]]
git-tree-sha1 = "bfc1187b79289637fa0ef6d4436ebdfe6905cbd6"
uuid = "e2d170a0-9d28-54be-80f0-106bbe20a464"
version = "1.0.0"

[[deps.DataValues]]
deps = ["DataValueInterfaces", "Dates"]
git-tree-sha1 = "d88a19299eba280a6d062e135a43f00323ae70bf"
uuid = "e7dc6d0d-1eca-5fa6-8ad6-5aecde8b7ea5"
version = "0.4.13"

[[deps.Dates]]
deps = ["Printf"]
uuid = "ade2ca70-3891-5945-98fb-dc099432e06a"

[[deps.DelimitedFiles]]
deps = ["Mmap"]
uuid = "8bb1440f-4735-579b-a4ab-409b98df4dab"

[[deps.DensityInterface]]
deps = ["InverseFunctions", "Test"]
git-tree-sha1 = "80c3e8639e3353e5d2912fb3a1916b8455e2494b"
uuid = "b429d917-457f-4dbc-8f4c-0cc954292b1d"
version = "0.4.0"

[[deps.DiffResults]]
deps = ["StaticArrays"]
git-tree-sha1 = "c18e98cba888c6c25d1c3b048e4b3380ca956805"
uuid = "163ba53b-c6d8-5494-b064-1a9d43ac40c5"
version = "1.0.3"

[[deps.DiffRules]]
deps = ["IrrationalConstants", "LogExpFunctions", "NaNMath", "Random", "SpecialFunctions"]
git-tree-sha1 = "dd933c4ef7b4c270aacd4eb88fa64c147492acf0"
uuid = "b552c78f-8df3-52c6-915a-8e097449b14b"
version = "1.10.0"

[[deps.Distances]]
deps = ["LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "3258d0659f812acde79e8a74b11f17ac06d0ca04"
uuid = "b4f34e82-e78d-54a5-968a-f98e89d6e8f7"
version = "0.10.7"

[[deps.Distributed]]
deps = ["Random", "Serialization", "Sockets"]
uuid = "8ba89e20-285c-5b6f-9357-94700520ee1b"

[[deps.Distributions]]
deps = ["ChainRulesCore", "DensityInterface", "FillArrays", "LinearAlgebra", "PDMats", "Printf", "QuadGK", "Random", "SparseArrays", "SpecialFunctions", "Statistics", "StatsBase", "StatsFuns", "Test"]
git-tree-sha1 = "5a4168170ede913a2cd679e53c2123cb4b889795"
uuid = "31c24e10-a181-5473-b8eb-7969acd0382f"
version = "0.25.53"

[[deps.DocStringExtensions]]
deps = ["LibGit2"]
git-tree-sha1 = "b19534d1895d702889b219c382a6e18010797f0b"
uuid = "ffbed154-4ef7-542d-bbb7-c09d3a79fcae"
version = "0.8.6"

[[deps.Downloads]]
deps = ["ArgTools", "LibCURL", "NetworkOptions"]
uuid = "f43a241f-c20a-4ad4-852c-f6b1247861c6"

[[deps.DualNumbers]]
deps = ["Calculus", "NaNMath", "SpecialFunctions"]
git-tree-sha1 = "5837a837389fccf076445fce071c8ddaea35a566"
uuid = "fa6b7ba4-c1ee-5f82-b5fc-ecf0adba8f74"
version = "0.6.8"

[[deps.EarCut_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "3f3a2501fa7236e9b911e0f7a588c657e822bb6d"
uuid = "5ae413db-bbd1-5e63-b57d-d24a61df00f5"
version = "2.2.3+0"

[[deps.Expat_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bad72f730e9e91c08d9427d5e8db95478a3c323d"
uuid = "2e619515-83b5-522b-bb60-26c02a35a201"
version = "2.4.8+0"

[[deps.FFMPEG]]
deps = ["FFMPEG_jll"]
git-tree-sha1 = "b57e3acbe22f8484b4b5ff66a7499717fe1a9cc8"
uuid = "c87230d0-a227-11e9-1b43-d7ebe4e7570a"
version = "0.4.1"

[[deps.FFMPEG_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "JLLWrappers", "LAME_jll", "Libdl", "Ogg_jll", "OpenSSL_jll", "Opus_jll", "Pkg", "Zlib_jll", "libass_jll", "libfdk_aac_jll", "libvorbis_jll", "x264_jll", "x265_jll"]
git-tree-sha1 = "d8a578692e3077ac998b50c0217dfd67f21d1e5f"
uuid = "b22a6f82-2f65-5046-a5b2-351ab43fb4e5"
version = "4.4.0+0"

[[deps.FFTW]]
deps = ["AbstractFFTs", "FFTW_jll", "LinearAlgebra", "MKL_jll", "Preferences", "Reexport"]
git-tree-sha1 = "505876577b5481e50d089c1c68899dfb6faebc62"
uuid = "7a1cc6ca-52ef-59f5-83cd-3a7055c09341"
version = "1.4.6"

[[deps.FFTW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c6033cc3892d0ef5bb9cd29b7f2f0331ea5184ea"
uuid = "f5851436-0d7a-5f13-b9de-f02708fd171a"
version = "3.3.10+0"

[[deps.FilePathsBase]]
deps = ["Compat", "Dates", "Mmap", "Printf", "Test", "UUIDs"]
git-tree-sha1 = "129b104185df66e408edd6625d480b7f9e9823a0"
uuid = "48062228-2e41-5def-b9a4-89aafe57970f"
version = "0.9.18"

[[deps.FillArrays]]
deps = ["LinearAlgebra", "Random", "SparseArrays", "Statistics"]
git-tree-sha1 = "246621d23d1f43e3b9c368bf3b72b2331a27c286"
uuid = "1a297f60-69ca-5386-bcde-b61e274b549b"
version = "0.13.2"

[[deps.FiniteDiff]]
deps = ["ArrayInterface", "LinearAlgebra", "Requires", "SparseArrays", "StaticArrays"]
git-tree-sha1 = "56956d1e4c1221000b7781104c58c34019792951"
uuid = "6a86dc24-6348-571c-b903-95158fe2bd41"
version = "2.11.0"

[[deps.FixedPointNumbers]]
deps = ["Statistics"]
git-tree-sha1 = "335bfdceacc84c5cdf16aadc768aa5ddfc5383cc"
uuid = "53c48c17-4a7d-5ca2-90c5-79b7896eea93"
version = "0.8.4"

[[deps.Fontconfig_jll]]
deps = ["Artifacts", "Bzip2_jll", "Expat_jll", "FreeType2_jll", "JLLWrappers", "Libdl", "Libuuid_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "21efd19106a55620a188615da6d3d06cd7f6ee03"
uuid = "a3f928ae-7b40-5064-980b-68af3947d34b"
version = "2.13.93+0"

[[deps.Formatting]]
deps = ["Printf"]
git-tree-sha1 = "8339d61043228fdd3eb658d86c926cb282ae72a8"
uuid = "59287772-0a20-5a39-b81b-1366585eb4c0"
version = "0.4.2"

[[deps.ForwardDiff]]
deps = ["CommonSubexpressions", "DiffResults", "DiffRules", "LinearAlgebra", "LogExpFunctions", "NaNMath", "Preferences", "Printf", "Random", "SpecialFunctions", "StaticArrays"]
git-tree-sha1 = "1bd6fc0c344fc0cbee1f42f8d2e7ec8253dda2d2"
uuid = "f6369f11-7733-5829-9624-2563aa707210"
version = "0.10.25"

[[deps.FreeType2_jll]]
deps = ["Artifacts", "Bzip2_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "87eb71354d8ec1a96d4a7636bd57a7347dde3ef9"
uuid = "d7e528f0-a631-5988-bf34-fe36492bcfd7"
version = "2.10.4+0"

[[deps.FriBidi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "aa31987c2ba8704e23c6c8ba8a4f769d5d7e4f91"
uuid = "559328eb-81f9-559d-9380-de523a88c83c"
version = "1.0.10+0"

[[deps.Future]]
deps = ["Random"]
uuid = "9fa8497b-333b-5362-9e8d-4d0656e87820"

[[deps.GLFW_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libglvnd_jll", "Pkg", "Xorg_libXcursor_jll", "Xorg_libXi_jll", "Xorg_libXinerama_jll", "Xorg_libXrandr_jll"]
git-tree-sha1 = "51d2dfe8e590fbd74e7a842cf6d13d8a2f45dc01"
uuid = "0656b61e-2033-5cc2-a64a-77c0f6c09b89"
version = "3.3.6+0"

[[deps.GR]]
deps = ["Base64", "DelimitedFiles", "GR_jll", "HTTP", "JSON", "Libdl", "LinearAlgebra", "Pkg", "Printf", "Random", "RelocatableFolders", "Serialization", "Sockets", "Test", "UUIDs"]
git-tree-sha1 = "af237c08bda486b74318c8070adb96efa6952530"
uuid = "28b8d3ca-fb5f-59d9-8090-bfdbd6d07a71"
version = "0.64.2"

[[deps.GR_jll]]
deps = ["Artifacts", "Bzip2_jll", "Cairo_jll", "FFMPEG_jll", "Fontconfig_jll", "GLFW_jll", "JLLWrappers", "JpegTurbo_jll", "Libdl", "Libtiff_jll", "Pixman_jll", "Pkg", "Qt5Base_jll", "Zlib_jll", "libpng_jll"]
git-tree-sha1 = "cd6efcf9dc746b06709df14e462f0a3fe0786b1e"
uuid = "d2c73de3-f751-5644-a686-071e5b155ba9"
version = "0.64.2+0"

[[deps.GeometryBasics]]
deps = ["EarCut_jll", "IterTools", "LinearAlgebra", "StaticArrays", "StructArrays", "Tables"]
git-tree-sha1 = "83ea630384a13fc4f002b77690bc0afeb4255ac9"
uuid = "5c1252a2-5f33-56bf-86c9-59e7332b4326"
version = "0.4.2"

[[deps.Gettext_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "9b02998aba7bf074d14de89f9d37ca24a1a0b046"
uuid = "78b55507-aeef-58d4-861c-77aaff3498b1"
version = "0.21.0+0"

[[deps.Glib_jll]]
deps = ["Artifacts", "Gettext_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Libiconv_jll", "Libmount_jll", "PCRE_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "a32d672ac2c967f3deb8a81d828afc739c838a06"
uuid = "7746bdde-850d-59dc-9ae8-88ece973131d"
version = "2.68.3+2"

[[deps.Graphite2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "344bf40dcab1073aca04aa0df4fb092f920e4011"
uuid = "3b182d85-2403-5c21-9c21-1e1f0cc25472"
version = "1.3.14+0"

[[deps.Grisu]]
git-tree-sha1 = "53bb909d1151e57e2484c3d1b53e19552b887fb2"
uuid = "42e2da0e-8278-4e71-bc24-59509adca0fe"
version = "1.0.2"

[[deps.HTTP]]
deps = ["Base64", "Dates", "IniFile", "Logging", "MbedTLS", "NetworkOptions", "Sockets", "URIs"]
git-tree-sha1 = "0fa77022fe4b511826b39c894c90daf5fce3334a"
uuid = "cd3eb016-35fb-5094-929b-558a96fad6f3"
version = "0.9.17"

[[deps.HarfBuzz_jll]]
deps = ["Artifacts", "Cairo_jll", "Fontconfig_jll", "FreeType2_jll", "Glib_jll", "Graphite2_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg"]
git-tree-sha1 = "129acf094d168394e80ee1dc4bc06ec835e510a3"
uuid = "2e76f6c2-a576-52d4-95c1-20adfe4de566"
version = "2.8.1+1"

[[deps.HypergeometricFunctions]]
deps = ["DualNumbers", "LinearAlgebra", "SpecialFunctions", "Test"]
git-tree-sha1 = "65e4589030ef3c44d3b90bdc5aac462b4bb05567"
uuid = "34004b35-14d8-5ef3-9330-4cdb6864b03a"
version = "0.3.8"

[[deps.Hyperscript]]
deps = ["Test"]
git-tree-sha1 = "8d511d5b81240fc8e6802386302675bdf47737b9"
uuid = "47d2ed2b-36de-50cf-bf87-49c2cf4b8b91"
version = "0.0.4"

[[deps.HypertextLiteral]]
git-tree-sha1 = "2b078b5a615c6c0396c77810d92ee8c6f470d238"
uuid = "ac1192a8-f4b3-4bfe-ba22-af5b92cd3ab2"
version = "0.9.3"

[[deps.IOCapture]]
deps = ["Logging", "Random"]
git-tree-sha1 = "f7be53659ab06ddc986428d3a9dcc95f6fa6705a"
uuid = "b5f81e59-6552-4d32-b1f0-c071b021bf89"
version = "0.2.2"

[[deps.IfElse]]
git-tree-sha1 = "debdd00ffef04665ccbb3e150747a77560e8fad1"
uuid = "615f187c-cbe4-4ef1-ba3b-2fcf58d6d173"
version = "0.1.1"

[[deps.IniFile]]
git-tree-sha1 = "f550e6e32074c939295eb5ea6de31849ac2c9625"
uuid = "83e8ac13-25f8-5344-8a64-a9f2b223428f"
version = "0.5.1"

[[deps.InlineStrings]]
deps = ["Parsers"]
git-tree-sha1 = "61feba885fac3a407465726d0c330b3055df897f"
uuid = "842dd82b-1e85-43dc-bf29-5d0ee9dffc48"
version = "1.1.2"

[[deps.IntelOpenMP_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "d979e54b71da82f3a65b62553da4fc3d18c9004c"
uuid = "1d5cc7b8-4909-519e-a0f8-d0f5ad9712d0"
version = "2018.0.3+2"

[[deps.InteractiveUtils]]
deps = ["Markdown"]
uuid = "b77e0a4c-d291-57a0-90e8-8db25a27a240"

[[deps.Interpolations]]
deps = ["AxisAlgorithms", "ChainRulesCore", "LinearAlgebra", "OffsetArrays", "Random", "Ratios", "Requires", "SharedArrays", "SparseArrays", "StaticArrays", "WoodburyMatrices"]
git-tree-sha1 = "b15fc0a95c564ca2e0a7ae12c1f095ca848ceb31"
uuid = "a98d9a8b-a2ab-59e6-89dd-64a1c18fca59"
version = "0.13.5"

[[deps.InverseFunctions]]
deps = ["Test"]
git-tree-sha1 = "91b5dcf362c5add98049e6c29ee756910b03051d"
uuid = "3587e190-3f89-42d0-90ee-14403ec27112"
version = "0.1.3"

[[deps.InvertedIndices]]
git-tree-sha1 = "bee5f1ef5bf65df56bdd2e40447590b272a5471f"
uuid = "41ab1584-1d38-5bbf-9106-f11c6c58b48f"
version = "1.1.0"

[[deps.IrrationalConstants]]
git-tree-sha1 = "7fd44fd4ff43fc60815f8e764c0f352b83c49151"
uuid = "92d709cd-6900-40b7-9082-c6be49f344b6"
version = "0.1.1"

[[deps.IterTools]]
git-tree-sha1 = "fa6287a4469f5e048d763df38279ee729fbd44e5"
uuid = "c8e1da08-722c-5040-9ed9-7db0dc04731e"
version = "1.4.0"

[[deps.IteratorInterfaceExtensions]]
git-tree-sha1 = "a3f24677c21f5bbe9d2a714f95dcd58337fb2856"
uuid = "82899510-4779-5014-852e-03e436cf321d"
version = "1.0.0"

[[deps.JLLWrappers]]
deps = ["Preferences"]
git-tree-sha1 = "abc9885a7ca2052a736a600f7fa66209f96506e1"
uuid = "692b3bcd-3c85-4b1f-b108-f13ce0eb3210"
version = "1.4.1"

[[deps.JSON]]
deps = ["Dates", "Mmap", "Parsers", "Unicode"]
git-tree-sha1 = "3c837543ddb02250ef42f4738347454f95079d4e"
uuid = "682c06a0-de6a-54ab-a142-c8b1cf79cde6"
version = "0.21.3"

[[deps.JpegTurbo_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b53380851c6e6664204efb2e62cd24fa5c47e4ba"
uuid = "aacddb02-875f-59d6-b918-886e6ef4fbf8"
version = "2.1.2+0"

[[deps.KernelDensity]]
deps = ["Distributions", "DocStringExtensions", "FFTW", "Interpolations", "StatsBase"]
git-tree-sha1 = "591e8dc09ad18386189610acafb970032c519707"
uuid = "5ab0869b-81aa-558d-bb23-cbf5423bbe9b"
version = "0.6.3"

[[deps.LAME_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "f6250b16881adf048549549fba48b1161acdac8c"
uuid = "c1c5ebd0-6772-5130-a774-d5fcae4a789d"
version = "3.100.1+0"

[[deps.LERC_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "bf36f528eec6634efc60d7ec062008f171071434"
uuid = "88015f11-f218-50d7-93a8-a6af411a945d"
version = "3.0.0+1"

[[deps.LZO_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e5b909bcf985c5e2605737d2ce278ed791b89be6"
uuid = "dd4b983a-f0e5-5f8d-a1b7-129d4a5fb1ac"
version = "2.10.1+0"

[[deps.LaTeXStrings]]
git-tree-sha1 = "f2355693d6778a178ade15952b7ac47a4ff97996"
uuid = "b964fa9f-0449-5b57-a5c2-d3ea65f4040f"
version = "1.3.0"

[[deps.Latexify]]
deps = ["Formatting", "InteractiveUtils", "LaTeXStrings", "MacroTools", "Markdown", "Printf", "Requires"]
git-tree-sha1 = "6f14549f7760d84b2db7a9b10b88cd3cc3025730"
uuid = "23fbe1c1-3f47-55db-b15f-69d7ec21a316"
version = "0.15.14"

[[deps.LazyArtifacts]]
deps = ["Artifacts", "Pkg"]
uuid = "4af54fe1-eca0-43a8-85a7-787d91b784e3"

[[deps.LibCURL]]
deps = ["LibCURL_jll", "MozillaCACerts_jll"]
uuid = "b27032c2-a3e7-50c8-80cd-2d36dbcbfd21"

[[deps.LibCURL_jll]]
deps = ["Artifacts", "LibSSH2_jll", "Libdl", "MbedTLS_jll", "Zlib_jll", "nghttp2_jll"]
uuid = "deac9b47-8bc7-5906-a0fe-35ac56dc84c0"

[[deps.LibGit2]]
deps = ["Base64", "NetworkOptions", "Printf", "SHA"]
uuid = "76f85450-5226-5b5a-8eaa-529ad045b433"

[[deps.LibSSH2_jll]]
deps = ["Artifacts", "Libdl", "MbedTLS_jll"]
uuid = "29816b5a-b9ab-546f-933c-edad1886dfa8"

[[deps.Libdl]]
uuid = "8f399da3-3557-5675-b5ff-fb832c97cbdb"

[[deps.Libffi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "0b4a5d71f3e5200a7dff793393e09dfc2d874290"
uuid = "e9f186c6-92d2-5b65-8a66-fee21dc1b490"
version = "3.2.2+1"

[[deps.Libgcrypt_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgpg_error_jll", "Pkg"]
git-tree-sha1 = "64613c82a59c120435c067c2b809fc61cf5166ae"
uuid = "d4300ac3-e22c-5743-9152-c294e39db1e4"
version = "1.8.7+0"

[[deps.Libglvnd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll", "Xorg_libXext_jll"]
git-tree-sha1 = "7739f837d6447403596a75d19ed01fd08d6f56bf"
uuid = "7e76a0d4-f3c7-5321-8279-8d96eeed0f29"
version = "1.3.0+3"

[[deps.Libgpg_error_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "c333716e46366857753e273ce6a69ee0945a6db9"
uuid = "7add5ba3-2f88-524e-9cd5-f83b8a55f7b8"
version = "1.42.0+0"

[[deps.Libiconv_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "42b62845d70a619f063a7da093d995ec8e15e778"
uuid = "94ce4f54-9a6c-5748-9c1c-f9c7231a4531"
version = "1.16.1+1"

[[deps.Libmount_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "9c30530bf0effd46e15e0fdcf2b8636e78cbbd73"
uuid = "4b2f31a3-9ecc-558c-b454-b3730dcb73e9"
version = "2.35.0+0"

[[deps.Libtiff_jll]]
deps = ["Artifacts", "JLLWrappers", "JpegTurbo_jll", "LERC_jll", "Libdl", "Pkg", "Zlib_jll", "Zstd_jll"]
git-tree-sha1 = "c9551dd26e31ab17b86cbd00c2ede019c08758eb"
uuid = "89763e89-9b03-5906-acba-b20f662cd828"
version = "4.3.0+1"

[[deps.Libuuid_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "7f3efec06033682db852f8b3bc3c1d2b0a0ab066"
uuid = "38a345b3-de98-5d2b-a5d3-14cd9215e700"
version = "2.36.0+0"

[[deps.LinearAlgebra]]
deps = ["Libdl", "libblastrampoline_jll"]
uuid = "37e2e46d-f89d-539d-b4ee-838fcccc9c8e"

[[deps.LogExpFunctions]]
deps = ["ChainRulesCore", "ChangesOfVariables", "DocStringExtensions", "InverseFunctions", "IrrationalConstants", "LinearAlgebra"]
git-tree-sha1 = "58f25e56b706f95125dcb796f39e1fb01d913a71"
uuid = "2ab3a3ac-af41-5b50-aa03-7779005ae688"
version = "0.3.10"

[[deps.Logging]]
uuid = "56ddb016-857b-54e1-b83d-db4d58db5568"

[[deps.LsqFit]]
deps = ["Distributions", "ForwardDiff", "LinearAlgebra", "NLSolversBase", "OptimBase", "Random", "StatsBase"]
git-tree-sha1 = "91aa1442e63a77f101aff01dec5a821a17f43922"
uuid = "2fda8390-95c7-5789-9bda-21331edee243"
version = "0.12.1"

[[deps.MKL_jll]]
deps = ["Artifacts", "IntelOpenMP_jll", "JLLWrappers", "LazyArtifacts", "Libdl", "Pkg"]
git-tree-sha1 = "e595b205efd49508358f7dc670a940c790204629"
uuid = "856f044c-d86e-5d09-b602-aeab76dc8ba7"
version = "2022.0.0+0"

[[deps.MacroTools]]
deps = ["Markdown", "Random"]
git-tree-sha1 = "3d3e902b31198a27340d0bf00d6ac452866021cf"
uuid = "1914dd2f-81c6-5fcd-8719-6d5c9610ff09"
version = "0.5.9"

[[deps.Markdown]]
deps = ["Base64"]
uuid = "d6f4376e-aef5-505a-96c1-9c027394607a"

[[deps.MbedTLS]]
deps = ["Dates", "MbedTLS_jll", "Random", "Sockets"]
git-tree-sha1 = "1c38e51c3d08ef2278062ebceade0e46cefc96fe"
uuid = "739be429-bea8-5141-9913-cc70e7f3736d"
version = "1.0.3"

[[deps.MbedTLS_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "c8ffd9c3-330d-5841-b78e-0817d7145fa1"

[[deps.Measures]]
git-tree-sha1 = "e498ddeee6f9fdb4551ce855a46f54dbd900245f"
uuid = "442fdcdd-2543-5da2-b0f3-8c86c306513e"
version = "0.3.1"

[[deps.Missings]]
deps = ["DataAPI"]
git-tree-sha1 = "bf210ce90b6c9eed32d25dbcae1ebc565df2687f"
uuid = "e1d29d7a-bbdc-5cf2-9ac0-f12de2c33e28"
version = "1.0.2"

[[deps.Mmap]]
uuid = "a63ad114-7e13-5084-954f-fe012c677804"

[[deps.MozillaCACerts_jll]]
uuid = "14a3606d-f60d-562e-9121-12d972cd8159"

[[deps.MultivariateStats]]
deps = ["Arpack", "LinearAlgebra", "SparseArrays", "Statistics", "StatsAPI", "StatsBase"]
git-tree-sha1 = "7008a3412d823e29d370ddc77411d593bd8a3d03"
uuid = "6f286f6a-111f-5878-ab1e-185364afe411"
version = "0.9.1"

[[deps.MutableArithmetics]]
deps = ["LinearAlgebra", "SparseArrays", "Test"]
git-tree-sha1 = "ba8c0f8732a24facba709388c74ba99dcbfdda1e"
uuid = "d8a4904e-b15c-11e9-3269-09a3773c0cb0"
version = "1.0.0"

[[deps.NLSolversBase]]
deps = ["DiffResults", "Distributed", "FiniteDiff", "ForwardDiff"]
git-tree-sha1 = "50310f934e55e5ca3912fb941dec199b49ca9b68"
uuid = "d41bc354-129a-5804-8e4c-c37616107c6c"
version = "7.8.2"

[[deps.NaNMath]]
git-tree-sha1 = "b086b7ea07f8e38cf122f5016af580881ac914fe"
uuid = "77ba4419-2d1f-58cd-9bb1-8ffee604a2e3"
version = "0.3.7"

[[deps.NearestNeighbors]]
deps = ["Distances", "StaticArrays"]
git-tree-sha1 = "ded92de95031d4a8c61dfb6ba9adb6f1d8016ddd"
uuid = "b8a86587-4115-5ab1-83bc-aa920d37bbce"
version = "0.4.10"

[[deps.NetworkOptions]]
uuid = "ca575930-c2e3-43a9-ace4-1e988b2c1908"

[[deps.Observables]]
git-tree-sha1 = "fe29afdef3d0c4a8286128d4e45cc50621b1e43d"
uuid = "510215fc-4207-5dde-b226-833fc4488ee2"
version = "0.4.0"

[[deps.OffsetArrays]]
deps = ["Adapt"]
git-tree-sha1 = "043017e0bdeff61cfbb7afeb558ab29536bbb5ed"
uuid = "6fe1bfb0-de20-5000-8ca7-80f57d26f881"
version = "1.10.8"

[[deps.Ogg_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "887579a3eb005446d514ab7aeac5d1d027658b8f"
uuid = "e7412a2a-1a6e-54c0-be00-318e2571c051"
version = "1.3.5+1"

[[deps.OpenBLAS_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Libdl"]
uuid = "4536629a-c528-5b80-bd46-f80d51c5b363"

[[deps.OpenLibm_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "05823500-19ac-5b8b-9628-191a04bc5112"

[[deps.OpenSSL_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ab05aa4cc89736e95915b01e7279e61b1bfe33b8"
uuid = "458c3c95-2e84-50aa-8efc-19380b2a3a95"
version = "1.1.14+0"

[[deps.OpenSpecFun_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "13652491f6856acfd2db29360e1bbcd4565d04f1"
uuid = "efe28fd5-8261-553b-a9e1-b2916fc3738e"
version = "0.5.5+0"

[[deps.OptimBase]]
deps = ["NLSolversBase", "Printf", "Reexport"]
git-tree-sha1 = "9cb1fee807b599b5f803809e85c81b582d2009d6"
uuid = "87e2bd06-a317-5318-96d9-3ecbac512eee"
version = "2.0.2"

[[deps.Opus_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "51a08fb14ec28da2ec7a927c4337e4332c2a4720"
uuid = "91d4177d-7536-5919-b921-800302f37372"
version = "1.3.2+0"

[[deps.OrderedCollections]]
git-tree-sha1 = "85f8e6578bf1f9ee0d11e7bb1b1456435479d47c"
uuid = "bac558e1-5e72-5ebc-8fee-abe8a469f55d"
version = "1.4.1"

[[deps.PCRE_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b2a7af664e098055a7529ad1a900ded962bca488"
uuid = "2f80f16e-611a-54ab-bc61-aa92de5b98fc"
version = "8.44.0+0"

[[deps.PDMats]]
deps = ["LinearAlgebra", "SparseArrays", "SuiteSparse"]
git-tree-sha1 = "e8185b83b9fc56eb6456200e873ce598ebc7f262"
uuid = "90014a1f-27ba-587c-ab20-58faa44d9150"
version = "0.11.7"

[[deps.Parsers]]
deps = ["Dates"]
git-tree-sha1 = "621f4f3b4977325b9128d5fae7a8b4829a0c2222"
uuid = "69de0a69-1ddd-5017-9359-2bf0b02dc9f0"
version = "2.2.4"

[[deps.Pixman_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "b4f5d02549a10e20780a24fce72bea96b6329e29"
uuid = "30392449-352a-5448-841d-b1acce4e97dc"
version = "0.40.1+0"

[[deps.Pkg]]
deps = ["Artifacts", "Dates", "Downloads", "LibGit2", "Libdl", "Logging", "Markdown", "Printf", "REPL", "Random", "SHA", "Serialization", "TOML", "Tar", "UUIDs", "p7zip_jll"]
uuid = "44cfe95a-1eb2-52ea-b672-e2afdf69b78f"

[[deps.PlotThemes]]
deps = ["PlotUtils", "Statistics"]
git-tree-sha1 = "8162b2f8547bc23876edd0c5181b27702ae58dce"
uuid = "ccf2f8ad-2431-5c83-bf29-c5338b663b6a"
version = "3.0.0"

[[deps.PlotUtils]]
deps = ["ColorSchemes", "Colors", "Dates", "Printf", "Random", "Reexport", "Statistics"]
git-tree-sha1 = "bb16469fd5224100e422f0b027d26c5a25de1200"
uuid = "995b91a9-d308-5afd-9ec6-746e21dbc043"
version = "1.2.0"

[[deps.Plots]]
deps = ["Base64", "Contour", "Dates", "Downloads", "FFMPEG", "FixedPointNumbers", "GR", "GeometryBasics", "JSON", "Latexify", "LinearAlgebra", "Measures", "NaNMath", "Pkg", "PlotThemes", "PlotUtils", "Printf", "REPL", "Random", "RecipesBase", "RecipesPipeline", "Reexport", "Requires", "Scratch", "Showoff", "SparseArrays", "Statistics", "StatsBase", "UUIDs", "UnicodeFun", "Unzip"]
git-tree-sha1 = "88ee01b02fba3c771ac4dce0dfc4ecf0cb6fb772"
uuid = "91a5bcdd-55d7-5caf-9e0b-520d859cae80"
version = "1.27.5"

[[deps.PlutoUI]]
deps = ["AbstractPlutoDingetjes", "Base64", "ColorTypes", "Dates", "Hyperscript", "HypertextLiteral", "IOCapture", "InteractiveUtils", "JSON", "Logging", "Markdown", "Random", "Reexport", "UUIDs"]
git-tree-sha1 = "670e559e5c8e191ded66fa9ea89c97f10376bb4c"
uuid = "7f904dfe-b85e-4ff6-b463-dae2292396a8"
version = "0.7.38"

[[deps.Polynomials]]
deps = ["LinearAlgebra", "MutableArithmetics", "RecipesBase"]
git-tree-sha1 = "0107e2f7f90cc7f756fee8a304987c574bbd7583"
uuid = "f27b6e38-b328-58d1-80ce-0feddd5e7a45"
version = "3.0.0"

[[deps.PooledArrays]]
deps = ["DataAPI", "Future"]
git-tree-sha1 = "28ef6c7ce353f0b35d0df0d5930e0d072c1f5b9b"
uuid = "2dfb63ee-cc39-5dd5-95bd-886bf059d720"
version = "1.4.1"

[[deps.Preferences]]
deps = ["TOML"]
git-tree-sha1 = "d3538e7f8a790dc8903519090857ef8e1283eecd"
uuid = "21216c6a-2e73-6563-6e65-726566657250"
version = "1.2.5"

[[deps.PrettyTables]]
deps = ["Crayons", "Formatting", "Markdown", "Reexport", "Tables"]
git-tree-sha1 = "dfb54c4e414caa595a1f2ed759b160f5a3ddcba5"
uuid = "08abe8d2-0d0c-5749-adfa-8a2ac140af0d"
version = "1.3.1"

[[deps.Printf]]
deps = ["Unicode"]
uuid = "de0858da-6303-5e67-8744-51eddeeeb8d7"

[[deps.Qt5Base_jll]]
deps = ["Artifacts", "CompilerSupportLibraries_jll", "Fontconfig_jll", "Glib_jll", "JLLWrappers", "Libdl", "Libglvnd_jll", "OpenSSL_jll", "Pkg", "Xorg_libXext_jll", "Xorg_libxcb_jll", "Xorg_xcb_util_image_jll", "Xorg_xcb_util_keysyms_jll", "Xorg_xcb_util_renderutil_jll", "Xorg_xcb_util_wm_jll", "Zlib_jll", "xkbcommon_jll"]
git-tree-sha1 = "c6c0f690d0cc7caddb74cef7aa847b824a16b256"
uuid = "ea2cea3b-5b76-57ae-a6ef-0a8af62496e1"
version = "5.15.3+1"

[[deps.QuadGK]]
deps = ["DataStructures", "LinearAlgebra"]
git-tree-sha1 = "78aadffb3efd2155af139781b8a8df1ef279ea39"
uuid = "1fd47b50-473d-5c70-9696-f719f8f3bcdc"
version = "2.4.2"

[[deps.REPL]]
deps = ["InteractiveUtils", "Markdown", "Sockets", "Unicode"]
uuid = "3fa0cd96-eef1-5676-8a61-b3b8758bbffb"

[[deps.Random]]
deps = ["SHA", "Serialization"]
uuid = "9a3f8284-a2c9-5f02-9a11-845980a1fd5c"

[[deps.Ratios]]
deps = ["Requires"]
git-tree-sha1 = "dc84268fe0e3335a62e315a3a7cf2afa7178a734"
uuid = "c84ed2f1-dad5-54f0-aa8e-dbefe2724439"
version = "0.4.3"

[[deps.RecipesBase]]
git-tree-sha1 = "6bf3f380ff52ce0832ddd3a2a7b9538ed1bcca7d"
uuid = "3cdcf5f2-1ef4-517c-9805-6587b60abb01"
version = "1.2.1"

[[deps.RecipesPipeline]]
deps = ["Dates", "NaNMath", "PlotUtils", "RecipesBase"]
git-tree-sha1 = "dc1e451e15d90347a7decc4221842a022b011714"
uuid = "01d81517-befc-4cb6-b9ec-a95719d0359c"
version = "0.5.2"

[[deps.Reexport]]
git-tree-sha1 = "45e428421666073eab6f2da5c9d310d99bb12f9b"
uuid = "189a3867-3050-52da-a836-e630ba90ab69"
version = "1.2.2"

[[deps.RelocatableFolders]]
deps = ["SHA", "Scratch"]
git-tree-sha1 = "cdbd3b1338c72ce29d9584fdbe9e9b70eeb5adca"
uuid = "05181044-ff0b-4ac5-8273-598c1e38db00"
version = "0.1.3"

[[deps.Requires]]
deps = ["UUIDs"]
git-tree-sha1 = "838a3a4188e2ded87a4f9f184b4b0d78a1e91cb7"
uuid = "ae029012-a4dd-5104-9daa-d747884805df"
version = "1.3.0"

[[deps.Rmath]]
deps = ["Random", "Rmath_jll"]
git-tree-sha1 = "bf3188feca147ce108c76ad82c2792c57abe7b1f"
uuid = "79098fc4-a85e-5d69-aa6a-4863f24498fa"
version = "0.7.0"

[[deps.Rmath_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "68db32dff12bb6127bac73c209881191bf0efbb7"
uuid = "f50d1b31-88e8-58de-be2c-1cc44531875f"
version = "0.3.0+0"

[[deps.SHA]]
uuid = "ea8e919c-243c-51af-8825-aaa63cd721ce"

[[deps.Scratch]]
deps = ["Dates"]
git-tree-sha1 = "0b4b7f1393cff97c33891da2a0bf69c6ed241fda"
uuid = "6c6a2e73-6563-6170-7368-637461726353"
version = "1.1.0"

[[deps.SentinelArrays]]
deps = ["Dates", "Random"]
git-tree-sha1 = "6a2f7d70512d205ca8c7ee31bfa9f142fe74310c"
uuid = "91c51154-3ec4-41a3-a24f-3f23e20d615c"
version = "1.3.12"

[[deps.Serialization]]
uuid = "9e88b42a-f829-5b0c-bbe9-9e923198166b"

[[deps.SharedArrays]]
deps = ["Distributed", "Mmap", "Random", "Serialization"]
uuid = "1a1011a3-84de-559e-8e89-a11a2f7dc383"

[[deps.Showoff]]
deps = ["Dates", "Grisu"]
git-tree-sha1 = "91eddf657aca81df9ae6ceb20b959ae5653ad1de"
uuid = "992d4aef-0814-514b-bc4d-f2e9a6c4116f"
version = "1.0.3"

[[deps.Sockets]]
uuid = "6462fe0b-24de-5631-8697-dd941f90decc"

[[deps.SortingAlgorithms]]
deps = ["DataStructures"]
git-tree-sha1 = "b3363d7460f7d098ca0912c69b082f75625d7508"
uuid = "a2af1166-a08f-5f64-846c-94a0d3cef48c"
version = "1.0.1"

[[deps.SparseArrays]]
deps = ["LinearAlgebra", "Random"]
uuid = "2f01184e-e22b-5df5-ae63-d93ebab69eaf"

[[deps.SpecialFunctions]]
deps = ["ChainRulesCore", "IrrationalConstants", "LogExpFunctions", "OpenLibm_jll", "OpenSpecFun_jll"]
git-tree-sha1 = "5ba658aeecaaf96923dce0da9e703bd1fe7666f9"
uuid = "276daf66-3868-5448-9aa4-cd146d93841b"
version = "2.1.4"

[[deps.Static]]
deps = ["IfElse"]
git-tree-sha1 = "87e9954dfa33fd145694e42337bdd3d5b07021a6"
uuid = "aedffcd0-7271-4cad-89d0-dc628f76c6d3"
version = "0.6.0"

[[deps.StaticArrays]]
deps = ["LinearAlgebra", "Random", "Statistics"]
git-tree-sha1 = "4f6ec5d99a28e1a749559ef7dd518663c5eca3d5"
uuid = "90137ffa-7385-5640-81b9-e52037218182"
version = "1.4.3"

[[deps.Statistics]]
deps = ["LinearAlgebra", "SparseArrays"]
uuid = "10745b16-79ce-11e8-11f9-7d13ad32a3b2"

[[deps.StatsAPI]]
deps = ["LinearAlgebra"]
git-tree-sha1 = "c3d8ba7f3fa0625b062b82853a7d5229cb728b6b"
uuid = "82ae8749-77ed-4fe6-ae5f-f523153014b0"
version = "1.2.1"

[[deps.StatsBase]]
deps = ["DataAPI", "DataStructures", "LinearAlgebra", "LogExpFunctions", "Missings", "Printf", "Random", "SortingAlgorithms", "SparseArrays", "Statistics", "StatsAPI"]
git-tree-sha1 = "8977b17906b0a1cc74ab2e3a05faa16cf08a8291"
uuid = "2913bbd2-ae8a-5f71-8c99-4fb6c76f3a91"
version = "0.33.16"

[[deps.StatsFuns]]
deps = ["ChainRulesCore", "HypergeometricFunctions", "InverseFunctions", "IrrationalConstants", "LogExpFunctions", "Reexport", "Rmath", "SpecialFunctions"]
git-tree-sha1 = "72e6abd6fc9ef0fa62a159713c83b7637a14b2b8"
uuid = "4c63d2b9-4356-54db-8cca-17b64c39e42c"
version = "0.9.17"

[[deps.StatsPlots]]
deps = ["AbstractFFTs", "Clustering", "DataStructures", "DataValues", "Distributions", "Interpolations", "KernelDensity", "LinearAlgebra", "MultivariateStats", "Observables", "Plots", "RecipesBase", "RecipesPipeline", "Reexport", "StatsBase", "TableOperations", "Tables", "Widgets"]
git-tree-sha1 = "4d9c69d65f1b270ad092de0abe13e859b8c55cad"
uuid = "f3b207a7-027a-5e70-b257-86293d7955fd"
version = "0.14.33"

[[deps.StructArrays]]
deps = ["Adapt", "DataAPI", "StaticArrays", "Tables"]
git-tree-sha1 = "57617b34fa34f91d536eb265df67c2d4519b8b98"
uuid = "09ab397b-f2b6-538f-b94a-2f83cf4a842a"
version = "0.6.5"

[[deps.SuiteSparse]]
deps = ["Libdl", "LinearAlgebra", "Serialization", "SparseArrays"]
uuid = "4607b0f0-06f3-5cda-b6b1-a6196a1729e9"

[[deps.TOML]]
deps = ["Dates"]
uuid = "fa267f1f-6049-4f14-aa54-33bafae1ed76"

[[deps.TableOperations]]
deps = ["SentinelArrays", "Tables", "Test"]
git-tree-sha1 = "e383c87cf2a1dc41fa30c093b2a19877c83e1bc1"
uuid = "ab02a1b2-a7df-11e8-156e-fb1833f50b87"
version = "1.2.0"

[[deps.TableTraits]]
deps = ["IteratorInterfaceExtensions"]
git-tree-sha1 = "c06b2f539df1c6efa794486abfb6ed2022561a39"
uuid = "3783bdb8-4a98-5b6b-af9a-565f29a5fe9c"
version = "1.0.1"

[[deps.Tables]]
deps = ["DataAPI", "DataValueInterfaces", "IteratorInterfaceExtensions", "LinearAlgebra", "OrderedCollections", "TableTraits", "Test"]
git-tree-sha1 = "5ce79ce186cc678bbb5c5681ca3379d1ddae11a1"
uuid = "bd369af6-aec1-5ad0-b16a-f7cc5008161c"
version = "1.7.0"

[[deps.Tar]]
deps = ["ArgTools", "SHA"]
uuid = "a4e569a6-e804-4fa4-b0f3-eef7a1d5b13e"

[[deps.Test]]
deps = ["InteractiveUtils", "Logging", "Random", "Serialization"]
uuid = "8dfed614-e22c-5e08-85e1-65c5234f0b40"

[[deps.TranscodingStreams]]
deps = ["Random", "Test"]
git-tree-sha1 = "216b95ea110b5972db65aa90f88d8d89dcb8851c"
uuid = "3bb67fe8-82b1-5028-8e26-92a6c54297fa"
version = "0.9.6"

[[deps.URIs]]
git-tree-sha1 = "97bbe755a53fe859669cd907f2d96aee8d2c1355"
uuid = "5c2747f8-b7ea-4ff2-ba2e-563bfd36b1d4"
version = "1.3.0"

[[deps.UUIDs]]
deps = ["Random", "SHA"]
uuid = "cf7118a7-6976-5b1a-9a39-7adc72f591a4"

[[deps.Unicode]]
uuid = "4ec0a83e-493e-50e2-b9ac-8f72acf5a8f5"

[[deps.UnicodeFun]]
deps = ["REPL"]
git-tree-sha1 = "53915e50200959667e78a92a418594b428dffddf"
uuid = "1cfade01-22cf-5700-b092-accc4b62d6e1"
version = "0.4.1"

[[deps.Unzip]]
git-tree-sha1 = "34db80951901073501137bdbc3d5a8e7bbd06670"
uuid = "41fe7b60-77ed-43a1-b4f0-825fd5a5650d"
version = "0.1.2"

[[deps.Wayland_jll]]
deps = ["Artifacts", "Expat_jll", "JLLWrappers", "Libdl", "Libffi_jll", "Pkg", "XML2_jll"]
git-tree-sha1 = "3e61f0b86f90dacb0bc0e73a0c5a83f6a8636e23"
uuid = "a2964d1f-97da-50d4-b82a-358c7fce9d89"
version = "1.19.0+0"

[[deps.Wayland_protocols_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4528479aa01ee1b3b4cd0e6faef0e04cf16466da"
uuid = "2381bf8a-dfd0-557d-9999-79630e7b1b91"
version = "1.25.0+0"

[[deps.WeakRefStrings]]
deps = ["DataAPI", "InlineStrings", "Parsers"]
git-tree-sha1 = "b1be2855ed9ed8eac54e5caff2afcdb442d52c23"
uuid = "ea10d353-3f73-51f8-a26c-33c1cb351aa5"
version = "1.4.2"

[[deps.Widgets]]
deps = ["Colors", "Dates", "Observables", "OrderedCollections"]
git-tree-sha1 = "505c31f585405fc375d99d02588f6ceaba791241"
uuid = "cc8bc4a8-27d6-5769-a93b-9d913e69aa62"
version = "0.6.5"

[[deps.WoodburyMatrices]]
deps = ["LinearAlgebra", "SparseArrays"]
git-tree-sha1 = "de67fa59e33ad156a590055375a30b23c40299d3"
uuid = "efce3f68-66dc-5838-9240-27a6d6f5f9b6"
version = "0.5.5"

[[deps.XML2_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libiconv_jll", "Pkg", "Zlib_jll"]
git-tree-sha1 = "1acf5bdf07aa0907e0a37d3718bb88d4b687b74a"
uuid = "02c8fc9c-b97f-50b9-bbe4-9be30ff0a78a"
version = "2.9.12+0"

[[deps.XSLT_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Libgcrypt_jll", "Libgpg_error_jll", "Libiconv_jll", "Pkg", "XML2_jll", "Zlib_jll"]
git-tree-sha1 = "91844873c4085240b95e795f692c4cec4d805f8a"
uuid = "aed1982a-8fda-507f-9586-7b0439959a61"
version = "1.1.34+0"

[[deps.Xorg_libX11_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll", "Xorg_xtrans_jll"]
git-tree-sha1 = "5be649d550f3f4b95308bf0183b82e2582876527"
uuid = "4f6342f7-b3d2-589e-9d20-edeb45f2b2bc"
version = "1.6.9+4"

[[deps.Xorg_libXau_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4e490d5c960c314f33885790ed410ff3a94ce67e"
uuid = "0c0b7dd1-d40b-584c-a123-a41640f87eec"
version = "1.0.9+4"

[[deps.Xorg_libXcursor_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXfixes_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "12e0eb3bc634fa2080c1c37fccf56f7c22989afd"
uuid = "935fb764-8cf2-53bf-bb30-45bb1f8bf724"
version = "1.2.0+4"

[[deps.Xorg_libXdmcp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fe47bd2247248125c428978740e18a681372dd4"
uuid = "a3789734-cfe1-5b06-b2d0-1dd0d9d62d05"
version = "1.1.3+4"

[[deps.Xorg_libXext_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "b7c0aa8c376b31e4852b360222848637f481f8c3"
uuid = "1082639a-0dae-5f34-9b06-72781eeb8cb3"
version = "1.3.4+4"

[[deps.Xorg_libXfixes_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "0e0dc7431e7a0587559f9294aeec269471c991a4"
uuid = "d091e8ba-531a-589c-9de9-94069b037ed8"
version = "5.0.3+4"

[[deps.Xorg_libXi_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXfixes_jll"]
git-tree-sha1 = "89b52bc2160aadc84d707093930ef0bffa641246"
uuid = "a51aa0fd-4e3c-5386-b890-e753decda492"
version = "1.7.10+4"

[[deps.Xorg_libXinerama_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll"]
git-tree-sha1 = "26be8b1c342929259317d8b9f7b53bf2bb73b123"
uuid = "d1454406-59df-5ea1-beac-c340f2130bc3"
version = "1.1.4+4"

[[deps.Xorg_libXrandr_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libXext_jll", "Xorg_libXrender_jll"]
git-tree-sha1 = "34cea83cb726fb58f325887bf0612c6b3fb17631"
uuid = "ec84b674-ba8e-5d96-8ba1-2a689ba10484"
version = "1.5.2+4"

[[deps.Xorg_libXrender_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "19560f30fd49f4d4efbe7002a1037f8c43d43b96"
uuid = "ea2f1a96-1ddc-540d-b46f-429655e07cfa"
version = "0.9.10+4"

[[deps.Xorg_libpthread_stubs_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "6783737e45d3c59a4a4c4091f5f88cdcf0908cbb"
uuid = "14d82f49-176c-5ed1-bb49-ad3f5cbd8c74"
version = "0.1.0+3"

[[deps.Xorg_libxcb_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "XSLT_jll", "Xorg_libXau_jll", "Xorg_libXdmcp_jll", "Xorg_libpthread_stubs_jll"]
git-tree-sha1 = "daf17f441228e7a3833846cd048892861cff16d6"
uuid = "c7cfdc94-dc32-55de-ac96-5a1b8d977c5b"
version = "1.13.0+3"

[[deps.Xorg_libxkbfile_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libX11_jll"]
git-tree-sha1 = "926af861744212db0eb001d9e40b5d16292080b2"
uuid = "cc61e674-0454-545c-8b26-ed2c68acab7a"
version = "1.1.0+4"

[[deps.Xorg_xcb_util_image_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "0fab0a40349ba1cba2c1da699243396ff8e94b97"
uuid = "12413925-8142-5f55-bb0e-6d7ca50bb09b"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxcb_jll"]
git-tree-sha1 = "e7fd7b2881fa2eaa72717420894d3938177862d1"
uuid = "2def613f-5ad1-5310-b15b-b15d46f528f5"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_keysyms_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "d1151e2c45a544f32441a567d1690e701ec89b00"
uuid = "975044d2-76e6-5fbe-bf08-97ce7c6574c7"
version = "0.4.0+1"

[[deps.Xorg_xcb_util_renderutil_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "dfd7a8f38d4613b6a575253b3174dd991ca6183e"
uuid = "0d47668e-0667-5a69-a72c-f761630bfb7e"
version = "0.3.9+1"

[[deps.Xorg_xcb_util_wm_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xcb_util_jll"]
git-tree-sha1 = "e78d10aab01a4a154142c5006ed44fd9e8e31b67"
uuid = "c22f9ab0-d5fe-5066-847c-f4bb1cd4e361"
version = "0.4.1+1"

[[deps.Xorg_xkbcomp_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_libxkbfile_jll"]
git-tree-sha1 = "4bcbf660f6c2e714f87e960a171b119d06ee163b"
uuid = "35661453-b289-5fab-8a00-3d9160c6a3a4"
version = "1.4.2+4"

[[deps.Xorg_xkeyboard_config_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Xorg_xkbcomp_jll"]
git-tree-sha1 = "5c8424f8a67c3f2209646d4425f3d415fee5931d"
uuid = "33bec58e-1273-512f-9401-5d533626f822"
version = "2.27.0+4"

[[deps.Xorg_xtrans_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "79c31e7844f6ecf779705fbc12146eb190b7d845"
uuid = "c5fb5394-a638-5e4d-96e5-b29de1b5cf10"
version = "1.4.0+3"

[[deps.Zlib_jll]]
deps = ["Libdl"]
uuid = "83775a58-1f1d-513f-b197-d71354ab007a"

[[deps.Zstd_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "e45044cd873ded54b6a5bac0eb5c971392cf1927"
uuid = "3161d3a3-bdf6-5164-811a-617609db77b4"
version = "1.5.2+0"

[[deps.libass_jll]]
deps = ["Artifacts", "Bzip2_jll", "FreeType2_jll", "FriBidi_jll", "HarfBuzz_jll", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "5982a94fcba20f02f42ace44b9894ee2b140fe47"
uuid = "0ac62f75-1d6f-5e53-bd7c-93b484bb37c0"
version = "0.15.1+0"

[[deps.libblastrampoline_jll]]
deps = ["Artifacts", "Libdl", "OpenBLAS_jll"]
uuid = "8e850b90-86db-534c-a0d3-1478176c7d93"

[[deps.libfdk_aac_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "daacc84a041563f965be61859a36e17c4e4fcd55"
uuid = "f638f0a6-7fb0-5443-88ba-1cc74229b280"
version = "2.0.2+0"

[[deps.libpng_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Zlib_jll"]
git-tree-sha1 = "94d180a6d2b5e55e447e2d27a29ed04fe79eb30c"
uuid = "b53b4c65-9356-5827-b1ea-8c7a1a84506f"
version = "1.6.38+0"

[[deps.libvorbis_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Ogg_jll", "Pkg"]
git-tree-sha1 = "b910cb81ef3fe6e78bf6acee440bda86fd6ae00c"
uuid = "f27f6e37-5d2b-51aa-960f-b287f2bc3b7a"
version = "1.3.7+1"

[[deps.nghttp2_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "8e850ede-7688-5339-a07c-302acd2aaf8d"

[[deps.p7zip_jll]]
deps = ["Artifacts", "Libdl"]
uuid = "3f19e933-33d8-53b3-aaab-bd5110c3b7a0"

[[deps.x264_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "4fea590b89e6ec504593146bf8b988b2c00922b2"
uuid = "1270edf5-f2f9-52d2-97e9-ab00b5d0237a"
version = "2021.5.5+0"

[[deps.x265_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg"]
git-tree-sha1 = "ee567a171cce03570d77ad3a43e90218e38937a9"
uuid = "dfaa095f-4041-5dcd-9319-2fabd8486b76"
version = "3.5.0+0"

[[deps.xkbcommon_jll]]
deps = ["Artifacts", "JLLWrappers", "Libdl", "Pkg", "Wayland_jll", "Wayland_protocols_jll", "Xorg_libxcb_jll", "Xorg_xkeyboard_config_jll"]
git-tree-sha1 = "ece2350174195bb31de1a63bea3a41ae1aa593b6"
uuid = "d8fb68d0-12a3-5cfd-a85a-d49703b185fd"
version = "0.9.1+5"
"""

# ╔═╡ Cell order:
# ╟─f5450eab-0f9f-4b7f-9b80-992d3c553ba9
# ╟─c58f76d9-45e8-4d72-9bce-f69321ee64d4
# ╟─f4be8945-c54d-4162-8ee1-2fe3cfb078f1
# ╟─dad2a7b0-f900-4a77-b7a3-b2b49d38ce14
# ╟─8cd8d8ea-5ece-4eec-8e46-13a52aed1d3a
# ╟─dcba4d9e-89d9-4fac-820a-fb24da9b1916
# ╠═049ea5c2-b2e9-4524-965e-0db726134f1d
# ╟─52f64c20-a045-4ee6-a307-f50af60eae49
# ╠═1868cca5-3cfb-4376-8468-d13831366cc9
# ╟─436b8f12-d833-42ec-b85c-31eb96ad862a
# ╠═70e91e6e-864a-4e9a-ab7d-c592833c1f59
# ╟─9ec97d94-274a-43e0-ae46-aa89d6149f0b
# ╟─88143e8d-1a08-4aca-9f42-63c39c8ec0e9
# ╠═ed832ad1-62f1-4ef6-a5d3-12e6bd2b60cd
# ╠═db816800-beb8-417b-a1dd-eab6b6939eb8
# ╠═d2ec129a-e27e-46fe-a066-6883cab53aab
# ╟─1213593e-89dc-44a7-94e9-9868bd08c715
# ╟─fe5d30f7-74f8-4b4b-b604-ee2d30fe8f33
# ╠═10c78be3-c1a3-4808-b136-189ddba7e53f
# ╟─23509c7d-9e69-4f25-9839-ea9785cb7b75
# ╟─dc930a35-3705-40bd-9832-b13b084da3f1
# ╠═22592e54-a24b-446d-bde0-93ec4c802b9b
# ╠═51626ee2-e509-4cae-9f0e-1cf448b5b5e0
# ╠═dbc3c042-3bb8-492c-810a-a3caf45ff794
# ╠═532ab0aa-bc85-49b7-a577-124109ab53a1
# ╟─1f7dc3da-ab8d-4bc5-8bba-ee1d82d6b7a4
# ╠═975e9fa8-d627-40a7-96ec-206b7e4809c7
# ╟─610cd280-d3b8-47c9-ad6e-4fb1577a6c4c
# ╟─00ec87d6-4b4d-42d7-a315-885ef16649a6
# ╟─3980b93b-dca5-41e8-9db5-b9ec5bb06b86
# ╠═447f26d1-41f1-4fe1-aa5c-004ec9d18a36
# ╟─0a755560-a580-41f2-9327-724882fb154f
# ╠═c7d415fc-9564-4f8b-b503-ae09f9d17bb9
# ╟─cdcd6224-6964-4774-a941-ff67c65d0568
# ╠═3b5ce183-9dc1-452f-aa7c-d1f35ad6614f
# ╟─c21b3673-2c16-4e28-b155-9e9ec54ca84f
# ╠═fded84d1-cb5b-4b51-940c-3772594e3aeb
# ╟─f20230a5-2fe9-4907-b5e4-13a98482eb56
# ╠═25b6f838-a496-4b4e-a456-478d4eb1b536
# ╟─98330947-bb95-4f2e-a380-991891a3328b
# ╠═84dc49a5-642f-42d1-8520-a1f338991531
# ╟─cb609ac3-0e0c-4db2-abb3-528371c46c46
# ╠═7e8bf5e0-284e-478c-89e1-08ffee174e13
# ╟─51c2555f-7040-4f56-840c-5e9462561d31
# ╠═12a9d1d8-a5ca-4500-a804-183821a9d026
# ╟─73c659cb-22df-460b-97ea-ddccb2ebb1bb
# ╟─eff8db42-396e-4570-8244-6c5cadd7d92e
# ╠═b19f652c-ec11-457d-8566-3aa53d3f6c71
# ╠═284bb169-bdaf-416a-8f5d-7fd53689913d
# ╟─5ae473fc-320d-4b75-8052-311fc074b5d9
# ╠═c3284711-b881-496d-b9ad-68d4865d60d2
# ╟─ba05d98f-605f-4c2f-a4bd-be91af6d60c8
# ╟─a5e5dfb3-81cc-4365-8036-c5b6444df798
# ╠═d17a2490-23a1-43ca-bf93-a26f08e8dbd5
# ╟─7df3ac3b-f6cd-4a43-9803-7cff9d544332
# ╠═f44f734c-4e33-4e3d-992c-d212e3925832
# ╟─7108dfab-f3f0-4c83-ba59-e5cb7307418c
# ╟─606efab3-a405-4cd5-a717-901a966da04c
# ╠═cb17d0e7-3e69-4279-83c8-15e5a92815c2
# ╟─ebe77f7a-b85b-409d-b57c-786354a385bc
# ╠═50779ec0-0cc2-420d-9337-89240cd31548
# ╟─e249afb3-2028-4b9e-828b-e757f2f27ee4
# ╟─11d40f7a-2c4c-4d64-843e-50824e19d10b
# ╠═11394695-2a1c-4192-be2f-32a5250d0edc
# ╟─29959a13-a44b-49c9-86a1-c54c64403ebd
# ╠═df8a3bc3-3980-4522-8a19-ee7264ea442e
# ╟─0f017280-7a66-49f3-81a7-70dcba51a6a7
# ╠═cd7b6262-004e-47bc-bacc-c23088a154b9
# ╟─a45c2888-98fe-42fc-b9ca-f307efb6831f
# ╟─f6fc5b01-6ea3-411f-bf12-878a4638bc01
# ╠═22e24d5a-5f53-4c38-ab48-fe3de8589057
# ╟─8a0f6def-dfb6-4aca-a440-dfda31dd232c
# ╠═d50a9c8b-08d8-4fcf-a2da-0c1cb0ff4021
# ╟─fa6d85be-0f22-438b-99b0-ec714ef2b514
# ╠═9a681882-c8bd-4c99-979e-ca632e37e173
# ╟─b6921ce5-7144-484b-96e0-5276eb244b36
# ╟─d879445f-3379-4b82-8fbe-05354de4b7a7
# ╠═e2018d1a-52ed-427b-9f1b-d6c50a1f18a5
# ╟─fcdde392-2566-4d03-a759-b736f5a26455
# ╟─cc65205c-776a-4dbb-b8d3-625d268a24ef
# ╟─be18fc94-6a7a-4959-8f02-9bc118969d18
# ╟─07e79d80-b780-44e2-869a-5e97bcd075c1
# ╟─ed6f00d8-9ade-47ca-86f6-7018f40426a2
# ╠═bedcae55-ad81-485a-872e-6cafb82bde86
# ╠═816438b7-4fc0-4581-a7a0-b375ec4e88be
# ╟─59832eb9-b4fa-4a5b-97a0-d96f532e82cc
# ╠═4de3b412-3ad3-448b-8f38-ea6ca09ce337
# ╟─0e889909-9ded-438f-bdd5-4989eb6cdddf
# ╟─af438416-7d6f-44b3-980e-cd6823688008
# ╟─64fe649e-9b17-451f-8d3f-7112514bb7fe
# ╠═11affb9f-2d9a-47a4-9cb1-2e6ead3de727
# ╟─aa04f999-0979-47a3-8694-7de7df4ebf21
# ╠═8997748b-bcd3-44e6-aecb-e003a3ed0a12
# ╟─6becffb6-1810-4c21-8d81-28cb2021cdfe
# ╠═30c6734d-4aad-4065-8604-7e3d91fa59fb
# ╟─a844007c-4e7d-4c47-b7e8-4ae39e9c0f02
# ╠═e908d5e3-563b-4982-8e5b-5e642bb62ef0
# ╟─2b1f9027-176f-46f9-981e-387042dddb2b
# ╟─f5d85c34-d26d-4e72-b64d-5baa966555db
# ╟─39dd4490-fbce-43c2-b216-721e73613281
# ╟─5799aa7b-ef1c-430e-8739-b755c6e743ad
# ╟─b68d6412-2656-43f3-a393-10e325b35d24
# ╟─510f698a-dee9-4e67-9ade-57289689f189
# ╠═f7d815df-8c7c-4994-9f4a-5d3697bac3ca
# ╠═7847ec0b-df92-4dd0-abe9-37dc8eae5b56
# ╟─ab22c5f2-908e-4bbf-a67a-4b1157a10023
# ╠═e7281c97-750b-473b-9860-e786a44e26a0
# ╟─80e3d9db-e6e9-4e64-9a28-123141079edb
# ╟─79810bad-ceb4-42a0-8b16-53f25004250b
# ╟─7ca6a708-e123-406a-9987-ad52f9323224
# ╟─58a063d6-6dd3-4e08-abe7-357e96d5eac9
# ╟─eaff35b0-be07-495d-9aec-92f1f64a2b22
# ╟─c100060d-1a84-47a6-bcdd-0105e23190d9
# ╠═288f3592-ab4c-434b-a882-5708959543ef
# ╠═47f61db3-26fe-4dee-9bc9-438434a94530
# ╟─8e1ad6b0-07ec-4d6d-baed-33046cb539dc
# ╟─d6660328-b1af-4c1b-94d4-48c58858f166
# ╟─6715ac8c-207c-4ec1-8b8d-c7e7ff5d8a6c
# ╟─99734a5a-f5f7-4168-9232-653802efaced
# ╟─80a96166-c072-4e5f-991e-9400ae506959
# ╟─a6d27afc-3984-4262-87e8-85eee8928560
# ╟─1270488f-b477-4385-86eb-46d4f5955d7f
# ╟─12fc470d-34cc-4ef2-9f56-cd3daf740818
# ╠═f03912ab-9f15-46fb-87f9-b7f38d7c61e1
# ╠═5283eb9f-c65e-4aaa-aa2a-3e4624cce6f9
# ╟─dafcdb72-fbcd-4602-93f4-ed3df42ac060
# ╠═00fd8596-437c-4a02-b6b1-d61c92931e3f
# ╟─4cc419da-89a8-4f12-b94c-881b4c1ba20e
# ╠═69726543-b247-44ce-b5e3-1672e9b5b3a1
# ╠═1749f0c5-ae4b-47e7-8733-e719d1386933
# ╠═2ee624de-2124-4f5e-82e6-46fd1c7dc62b
# ╠═d326a92d-23b2-43d4-b984-c51b9dd6a905
# ╟─00000000-0000-0000-0000-000000000001
# ╟─00000000-0000-0000-0000-000000000002
