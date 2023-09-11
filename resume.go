package main 

import (
	"text/template"
	"gopkg.in/yaml.v2"
    "log"
    "io/ioutil"
	"os"
	"strings"
)

type skillGroups struct { 
	Name string `yaml:"name"`
	Skills []string `yaml:"skills"`
}

func (m skillGroups) GetSkills() string {
	return strings.Join(m.Skills[:], ", ")
}

type experience struct {
  	Company string `yaml:"company"`
    Role string `yaml:"role"`
    Location string `yaml:"location"`
    StartDate string `yaml:"start_date"`
    EndDate string `yaml:"end_date"`
    Bullets []string `yaml:"bullets"`
}


type education struct {
	InstitutionName string `yaml:"institution_name"`
	Location string `yaml:"location"`
	DegreeName string `yaml:"degree_name"`
	GraduationDate string `yaml:"graduation_date"`
}


type contact struct {
	FirstName string `yaml:"first_name"`
	LastName string `yaml:"last_name"` 
	Phone string `yaml:"phone"`
	Address string `yaml:"address"`
	Email string `yaml:"email"`
	Github string `yaml:"github"`
	Linkedin string `yaml:"linkedin"`
}


type content struct {
	Experience []experience `yaml:"experience"`
	SkillGroups []skillGroups `yaml:"skill_groups"`
	Education []education `yaml:"education"`
	Contact contact
}


func main() {
	var resumeContent content
	    yamlFile, err := ioutil.ReadFile("content.yaml")
    if err != nil {
        log.Printf("yamlFile.Get err   #%v ", err)
    }
     err = yaml.Unmarshal(yamlFile, &resumeContent)
     if err != nil {
         log.Fatalf("Unmarshal: %v", err)
     }
	var tmplFile = "resume.tpl.tex"
	tmpl, err := template.New(tmplFile).ParseFiles(tmplFile)
	if err != nil {
		panic(err)
	}	
	var f *os.File
	f, err = os.Create("resume.tex")
	if err != nil {
		panic(err)
	}
	err = tmpl.Execute(f, resumeContent)
	if err != nil {
		panic(err)
	}
	err = f.Close()
	if err != nil {
		panic(err)
	}
}
