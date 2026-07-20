# 🧭 Project Ajirika — Building a Standard for the Data CV
Hiring has evolved — from handwritten letters and printed CVs, to email attachments, and now to online job application portals.
These portals have made life easier for HR teams — but for applicants, each submission still takes time and effort to re-enter the same details over and over again.

**Project Ajirika** is starting a conversation around this.
> 💡 *What if we had a standard data structure for job applications — where an applicant could upload one structured “data CV” that any portal could read?*
This would:
- Save time for applicants  
- Ensure accuracy across job submissions  
- Make job matching more efficient  
- Enable AI-assisted CV writing and job matching

---
## 🎯 Our Goals
1. **Reusable JSON CV Format**  
   Create a portable, machine-readable `JSON` CV format that applicants can use across multiple job portals.
2. **Unified CV Platform**  
   Build a central open-source platform for job seekers to update, export, and share their CVs in the standard format.
3. **HR Standardization**  
   Collaborate with the HR community in Kenya to standardize key CV data fields and metadata.
4. **Open Source Development**  
   Foster an active open-source community to evolve the schema and tools continuously.
---
## 🕓 Project History
| Date | Milestone | Description |
|------|------------|-------------|
| **October 2025** | Concept Meeting | Initial idea of a standardized data CV format discussed. |
| **October 2025** | Brainstorming | Drafted problem statements and project goals. |
| **Ongoing** | Research | Analyzing existing global standards such as [JSON Resume](https://jsonresume.org/) and [HR Open Standards](https://hropenstandards.org/). |
---
## 🚀 Current Action Items
| 🧩 Area | Description |
|---------|-------------|
| 🔍 **Research Standards** | Conduct detailed research on global CV data formats and standards. |
| 👥 **HR Community Engagement** | Engage HR professionals in Kenya to discuss CV standardization and metadata. |
| 📄 **Document Challenges** | Collect real-world pain points from job seekers and HR practitioners. |
| 💻 **Open Source Setup** | Set up a GitHub repository to collaborate on schema design and tool development. |
---
## 🧭 Next Steps
| Step | Description |
|------|-------------|
| 🧮 **Survey Adoption** | Assess adoption of existing standards (JSON Resume, HR Open Standards) among Kenyan HR systems and job portals. |
| ⚙️ **Define Core Schema** | Define the minimum viable schema — distinguishing between core and optional fields. |
| 🎓 **Local Customization** | Incorporate Kenyan education and certification standards to ensure local relevance. |
---

# Ajirika Full Setup & Workflow Guide

## Initial Project Setup

**1. Install prerequisites**

```bash
sudo apt install openjdk-21-jdk maven postgresql
```

Ajirika is a Java/Maven web app (WAR package) requiring Java 21 and PostgreSQL.

**2. Clone the repo**

```bash
git clone https://github.com/OpenBaraza/ajirika.git
cd ajirika
```

**3. Set up the database**

```bash
sudo -u postgres createdb ajirika
psql -U postgres -d ajirika -f db/01.baraza.sql
psql -U postgres -d ajirika -f db/02.profile.sql
```

Always run `01.baraza.sql` before `02.profile.sql`.

**4. Configure database credentials (do this before building)**

```bash
nano src/main/webapp/META-INF/context.xml
```

Edit the `username`/`password` to match your local Postgres user.

**5. Build the project**

```bash
mvn clean package
```

Downloads dependencies (including the ~400MB Stanford CoreNLP models expect this to take a while) and produces `target/ajirika.war`.

**6. Deploy to Tomcat**

```bash
sudo /path/to/tomcat/bin/shutdown.sh
sudo cp target/ajirika.war /path/to/tomcat/webapps/
sudo /path/to/tomcat/bin/startup.sh
```

Replace `/path/to/tomcat` with your actual Tomcat install path.

**7. Access the app**

[localhost](localhost:8080/ajirika)

---

## The "Annotation → Training → Deploy" Cycle

**Step 1: Annotate CVs**
Use the app's UI to annotate CVs. This writes annotation data into the live Tomcat deployment at `webapps/ajirika/WEB-INF/ner-training/cv-train.tsv`.

**Step 2: Pull the annotated data back into your source tree**

```bash
sudo cp /path/to/tomcat/webapps/ajirika/WEB-INF/ner-training/cv-train.tsv \
   ~/path/to/ajirika/src/main/webapp/WEB-INF/ner-training/cv-train.tsv
```

Replace `/path/to/tomcat` and `~/path/to/ajirika` with your actual paths. `sudo` is needed since Tomcat owns those files.

**Step 3: Train the NER model**

```bash
java -Xmx4g -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -prop src/main/webapp/WEB-INF/ner-training/ner-training.properties
```

Run from the repo root. Produces `cv-ner-model.ser.gz` at the path set in `ner-training.properties`.

**Step 4: Sanity-check the model (optional)**

Run from the repo root:

```bash
java -Xmx2g -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -loadClassifier src/main/webapp/WEB-INF/ner-training/cv-ner-model.ser.gz -readStdin
```

Paste sample text into stdin to eyeball whether the new model tags entities correctly before deploying it.

**Step 5: Copy the trained model into resources**

```bash
cp src/main/webapp/WEB-INF/ner-training/cv-ner-model.ser.gz \
   src/main/resources/models/cv-ner-model.ser.gz
```

**Step 6: Compile**

```bash
mvn clean compile -Dmaven.test.skip=true
```

**Step 7: Package and redeploy**

```bash
mvn package -Dmaven.test.skip=true && \
sudo /path/to/tomcat/bin/shutdown.sh && \
sudo rm -rf /path/to/tomcat/webapps/ajirika /path/to/tomcat/webapps/ajirika.war && \
sudo cp target/ajirika.war /path/to/tomcat/webapps/ && \
export JAVA_OPTS="-Xmx4g -Xms512m" && \
sudo -E /path/to/tomcat/bin/startup.sh
```

**Step 8: Watch the logs**

```bash
tail -f /path/to/tomcat/logs/catalina.out
```

Run in a separate terminal during redeploy to catch startup errors immediately.

---

## Quick Reference: Combined Commands

**Full training pipeline** (pull data → train → copy model):

```bash
sudo cp /path/to/tomcat/webapps/ajirika/WEB-INF/ner-training/cv-train.tsv \
   ~/path/to/ajirika/src/main/webapp/WEB-INF/ner-training/cv-train.tsv && \
java -Xmx4g -cp ~/.m2/repository/edu/stanford/nlp/stanford-corenlp/4.5.10/stanford-corenlp-4.5.10.jar \
  edu.stanford.nlp.ie.crf.CRFClassifier \
  -prop src/main/webapp/WEB-INF/ner-training/ner-training.properties && \
cp src/main/webapp/WEB-INF/ner-training/cv-ner-model.ser.gz \
   src/main/resources/models/cv-ner-model.ser.gz
```

**Deploy** (compile → package → redeploy to Tomcat):

```bash
mvn clean compile -Dmaven.test.skip=true && \
mvn package -Dmaven.test.skip=true && \
sudo /path/to/tomcat/bin/shutdown.sh && \
sudo rm -rf /path/to/tomcat/webapps/ajirika /path/to/tomcat/webapps/ajirika.war && \
sudo cp target/ajirika.war /path/to/tomcat/webapps/ && \
export JAVA_OPTS="-Xmx4g -Xms512m" && \
sudo -E /path/to/tomcat/bin/startup.sh
```

Replace `/path/to/tomcat` and `~/path/to/ajirika` with your actual paths.

**End-to-end after new annotations:** run the full training pipeline, then run deploy, then tail the logs to confirm it came up clean.

---

## 💬 Join the Conversation
We’re looking for **HR professionals**, **developers**, and **community contributors** who believe in creating a more efficient and transparent hiring ecosystem.
👉 **Ways to Get Involved**
- 🧑‍💼 Join the HR community discussions  
- 💻 Contribute to our open-source GitHub repository  
- 🗣️ Participate in surveys and schema workshops  
---
## 📘 License
Project Ajirika is an **open-source initiative** dedicated to creating public standards for CV data formats.  
License details will be finalized with community input.
