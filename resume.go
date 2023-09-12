package main 

import (
	"text/template"
	"gopkg.in/yaml.v2"
    "log"
	"flag"
	"fmt"
    "io/ioutil"
	"os"
	"os/exec"
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
}


type resumeData struct {
	Content content
	Contact contact
}


var profile = flag.String("profile", "", "a string")


func main() {

    flag.Parse()	
	if *profile == "" {
        log.Printf("profile flag required")
		return
	}
	var resumeContent content
	var contact_info contact
	var resume_data resumeData 

	// Read content file
	profile_folder := fmt.Sprintf("./profiles/%s", *profile)
	yamlFile, err := ioutil.ReadFile(fmt.Sprintf("%s/content.yaml", profile_folder))
    if err != nil {
        log.Printf("yamlFile.Get err   #%v ", err)
    }
    err = yaml.Unmarshal(yamlFile, &resumeContent)
    if err != nil {
        log.Fatalf("Unmarshal: %v", err)
    }

	// Read content file
	// Default to anonymous, offer parameter for live	
	yamlFile, err = ioutil.ReadFile(fmt.Sprintf("%s/contact.yaml", profile_folder))
    if err != nil {
        log.Printf("yamlFile.Get err   #%v ", err)
    }
    err = yaml.Unmarshal(yamlFile, &contact_info)
    if err != nil {
        log.Fatalf("Unmarshal: %v", err)
    }

	// combine content and contact into resume_data
	resume_data = resumeData{
		Content: resumeContent,
		Contact: contact_info,
	}
	var tmplFile = "resume.tpl.tex"
	tmpl, err := template.New(tmplFile).ParseFiles(tmplFile)
	if err != nil {
		panic(err)
	}	
	
	output_folder := "./.resume"
    err = os.MkdirAll(output_folder, 0755)

	var f *os.File
	tex_file := fmt.Sprintf("%s/resume.tex", output_folder)
	f, err = os.Create(tex_file)
	if err != nil {
		panic(err)
	}
	err = tmpl.Execute(f, resume_data)
	if err != nil {
		panic(err)
	}
	err = f.Close()
	if err != nil {
		panic(err)
	}

	// Run latex command 	
	cmd := exec.Command("pdflatex", "-output-dir", output_folder, tex_file)
    _, err = cmd.Output()

    if err != nil {
		panic(err)
    } 

	// Move to root
	pdf_file := "resume.pdf"
	err = os.Rename(fmt.Sprintf("%s/%s", output_folder, pdf_file), pdf_file)
    if err != nil {
		panic(err)
    } 
	err = os.RemoveAll(output_folder)
    if err != nil {
		panic(err)
    } 
}

