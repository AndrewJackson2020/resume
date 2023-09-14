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


// TODO Attach to struct?
func buildResumeData(profile_folder string) resumeData {

	var contact_info contact
	var resumeContent content
	// Read content file
	yamlFile, err := ioutil.ReadFile(fmt.Sprintf("%s/content.yaml", profile_folder))
    if err != nil {
        log.Printf("yamlFile.Get err   #%v ", err)
    }
    err = yaml.Unmarshal(yamlFile, &resumeContent)
    if err != nil {
        log.Fatalf("Unmarshal: %v", err)
    }

	// Read content file
	yamlFile, err = ioutil.ReadFile(fmt.Sprintf("%s/contact.yaml", profile_folder))
    if err != nil {
        log.Printf("yamlFile.Get err   #%v ", err)
    }
    err = yaml.Unmarshal(yamlFile, &contact_info)
    if err != nil {
        log.Fatalf("Unmarshal: %v", err)
    }

	// combine content and contact into resume_data
	var resume_data = resumeData{
		Content: resumeContent,
		Contact: contact_info,
	}
	return resume_data
}


func childIfExists(parent string, child string) string {
	value := parent
	if child != "" {
		value = child
	}
	return value 
}


func combineResumeData(parent resumeData, child resumeData) resumeData {

	var new_experiences []experience = []experience{}
    for i := 0; i < len(parent.Content.Experience); i++ {
		new_experience := experience{
			Company: childIfExists(
				parent.Content.Experience[i].Company, 
				child.Content.Experience[i].Company),
			Role: childIfExists(
				parent.Content.Experience[i].Role, 
				child.Content.Experience[i].Role),
			Location: childIfExists(
				parent.Content.Experience[i].Location, 
				child.Content.Experience[i].Location),
			StartDate: childIfExists(
				parent.Content.Experience[i].StartDate, 
				child.Content.Experience[i].StartDate),
			EndDate: childIfExists(
				parent.Content.Experience[i].EndDate, 
				child.Content.Experience[i].EndDate),
			Bullets: parent.Content.Experience[i].Bullets, 
		} 
		
		new_experiences = append(new_experiences, new_experience)
    }	

	var new_educations []education = []education{}
    for i := 0; i < len(parent.Content.Education); i++ {
		new_education := education{
			InstitutionName:childIfExists(
				parent.Content.Education[i].InstitutionName,
				child.Content.Education[i].InstitutionName,
			),
			Location: childIfExists(
				parent.Content.Education[i].Location,
				child.Content.Education[i].Location,
			),
			DegreeName: childIfExists(
				parent.Content.Education[i].DegreeName,
				child.Content.Education[i].DegreeName,
			),
			GraduationDate: childIfExists(
				parent.Content.Education[i].GraduationDate,
				child.Content.Education[i].GraduationDate,
			),
		} 
		
		new_educations = append(new_educations, new_education)
    }	


	newResumeData := resumeData{

		Content: content{
			Experience: new_experiences,
			SkillGroups: parent.Content.SkillGroups,
			Education: new_educations,
		},

		Contact: contact{
			FirstName: childIfExists(parent.Contact.FirstName, child.Contact.FirstName),
			LastName: childIfExists(parent.Contact.LastName, child.Contact.LastName),
			Phone: childIfExists(parent.Contact.Phone, child.Contact.Phone),
			Address: childIfExists(parent.Contact.Address, child.Contact.Address),
			Email: childIfExists(parent.Contact.Email, child.Contact.Email),
			Github: childIfExists(parent.Contact.Github, child.Contact.Github),
			Linkedin: childIfExists(parent.Contact.Linkedin, child.Contact.Linkedin),
		},
	}
	return newResumeData		
}


func main() {

    flag.Parse()	

	base_folder := "./profiles"

	resume_data_combined := buildResumeData(base_folder)

	if *profile != "" {
		profile_folder := fmt.Sprintf("./profiles/%s", *profile)
		resume_data_profile := buildResumeData(profile_folder)
		resume_data_combined = combineResumeData(resume_data_profile, resume_data_profile)
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
	err = tmpl.Execute(f, resume_data_combined)
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

