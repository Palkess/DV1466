# Project A: Web Spider

## Task

Implement a simple web-spider that can follow the structure of the mechani.se site, and use visualisation tools to render this structure.

## Description

A web-spider is a program that builds a model of the web. Starting from one (or more) known addresses, it loads the web-pages that it knows about, scrapes the links from them to discover new site and repeats until it has built a copy of ("spidered") the entire web. Your problem is more modest - you just need to map out the structure of mechani.se and its associated sub-domains, then produce some visualisations using the tools introduced in the final lecture. To break the problem down into more managable pieces you will write (up to) four separate scripts.

### Script one: page scanner

The first script will take care of scanning a single page, it should take two arguments: a domain, and a path, e.g. <span style="font-family:monospace">./script1.bash mechani.se /unix/public/cw4a.html</span>. Build the url and use curl to fetch the page body. The script should find all anchor tags with href attributes and extract the link addresses. These may be local paths (on the same domain) e.g. /scripts/thing.asp, or a target domain e.g. http://example.com, or a target domain and a path on that system, e.g. https://example.com/siteb/index.html. The output of this script should be a list of records, one per link, with four fields: source domain, source path, target domain and target path. The paths outside the domain being scanned are not necessary and may be discarded.

Choose a way to represent these four items on each line so that you can process them in your second script. [Here is a sample](cw4aWorklistExample.txt) from the format that I used when I tested this task out. Please note - I have chosen to use spaces as separators and normalise blank paths as single slashes. This is because I know a way to process this easily, you should choose a format that allows you to write the second script as easily as possible.

### Script two: dispatch loop

The second script will start by calling the first on this page (./script1.bash mechani.se /unix/public/cw4a.html). It will store the results into a worklist in a temporary file. For each record (job) in the worklist it will call the first script if that page has not already been scraped. If the target domain does not match the source then the page will be skipped (spidering our own website is fine, but crossing into other domains may annoy people). The combined output of this pass will be merged together into a much bigger worklist, this will be written to the disk as a file called <span style="font-family:monospace">result</span>.

[Here is a sample](cw4aWorklistExample2.txt) of the second-level worklist after running script2.bash once. Each of the target domain, target path pairs in the first worklist has been scanned and produced a block in the second list where that page becomes the common source domain, source path. The target domain, target paths shown in this file are those reachable from the front page with two clicks.

### Script three: GraphViz network

Read the result file in the current directory and convert it into a GraphViz .dot file containing a digraph, i.e. I should be able to run this script immediately after script1, script2 or script4 to visualise their output. Each node name should be the path name of files inside the scanning domain, and just the domain name for targets outside the domain. When you run the resulting file through <span style="monospace">dot -Tsvg</span> it will produce an output that looks similar to [this](cw4aGraphviz.svg). Note: this is the output of script4 called on /unix/public/cw4.html so it includes a few extra nodes.

### Script four: dispatch loop

A modification of script2 that repeatedly generates worklists while there are records for paths that remain unscanned. Each new worklist is a level of the graph of pages linked to from the starting point - the fourth script is computing a breadth-first-search of the web from the given starting point. The final output of the script is shown in [this page.](cw4aWorklistExample3.txt)

## Tasks / Grading Rubric

Each grade specification is cumulative: e.g. to receive a grade C your project must also fulfil the requirements for grade D and grade E.

<table>

<tbody>

<tr>

<td>Grade</td>

<td>Requirements</td>

</tr>

<tr>

<td>E</td>

<td>Write script1.bash so that it scans the target page and outputs one record per link.</td>

</tr>

<tr>

<td></td>

<td>

*   script1.bash must find all outgoing links in anchor-tag href-parameters on the specified page.
*   script1.bash must filter out any links that go to protocols other than http / https.
*   script1.bash must output (to stdout) a one-line record for each link indicating the source domain, source absolute path, target domain, target absolute path.
*   script1.bash must handle URLS that enode local paths, target domains and target domains with paths correctly with respect to the fields in the one-line record generated.
*   script1.bash must resolve relative paths.
*   script1.bash must remove arguments from links (the question-mark and anything that follows) to only record the paths.

</td>

</tr>

<tr>

<td>D</td>

<td>Write script2.bash so that it scans one-level deep from the start (so every page linked from the first page is also scanned).</td>

</tr>

<tr>

<td></td>

<td>

*   script2.bash must process each target domain,path in the worklist to try and scan that page (unless scanned before).
*   script2.bash must use the same output format as script1.bash.
*   script2.bash should call script1.bash to scan each page.
*   script2.bash must output into a file called "result" in the current directory.
*   The combination of both scripts must ensure that no page is scanned twice during the execution of script2.bash.

</td>

</tr>

<tr>

<td>C</td>

<td>Write script3.bash so that it generates the GraphViz description of the output from the file "result" in the current directory.</td>

</tr>

<tr>

<td>A</td>

<td>Write script4.bash using the same argument pattern and output format as script2 so that it scans until it is complete - it recovers a full list of URLs reachable from the starting page without leaving the domain, does not scan any page more than once, and terminates cleanly when there is nothing left to scan.</td>

</tr>

</tbody>

</table>

### Test Data

You can mostly ignore this section, the instructions point you to this page to seed the spiders, so here are some outgoing links for the spider to process: [strip mailtos](mailto:should.be.excluded@nowhere.com) [checking relative path normalisation](../public/spider1.html) [goes to same place](/unix/public/spider1.html) [in same directory](spider2.html)[to an external address](http://www.google.com)
