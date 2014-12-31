package main

import (
	"bufio"
	"encoding/csv"
	"fmt"
	"github.com/PuerkitoBio/goquery"
	"io/ioutil"
	"os"
	"strings"
)

func check(e error) {
	if e != nil {
		panic(e)
	}
}

func CsvIze() {
	csvfile, err := os.Create("output.csv")
	writer := csv.NewWriter(csvfile)
	check(err)
	files, err := ioutil.ReadDir("results")
	check(err)

	writer.Write([]string{"ssl", "address", "owner", "neighborhood", "sub_neighborhood", "use_code", "2014_assessment"})

	for _, name := range files {
		fmt.Printf("scanning %s\n", name.Name())
		handle, err := os.Open("results/" + name.Name())
		dat := bufio.NewReader(handle)
		doc, err := goquery.NewDocumentFromReader(dat)
		check(err)
		doc.Find("table").Each(func(i int, s *goquery.Selection) {
			if i == 3 {
				s.Find("tr").Each(func(j int, row *goquery.Selection) {
					var tds = row.Find("td")
					if tds.Length() == 7 {
						var cells []string
						tds.Each(func(k int, td *goquery.Selection) {
							cells = append(cells, strings.TrimSpace(td.Text()))
						})
						err := writer.Write(cells)
						check(err)
					}
				})
			}
		})
	}

	writer.Flush()
}

func main() {
	CsvIze()
}
