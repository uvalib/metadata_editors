UVaLib's mighty metadata editors, built over Orbeon XForms/FormsRunner.

Edit WEB-INF/resources/config/properties-local.xml to change

<property as="xs:anyURI" name="oxf.fr.persistence.fedora.uri"
        value="http://localhost:8000/repository/orbeon-integration"/>

to aim at a Orbeon-CRUD interface for a repository, the service
deployments of which are aimed back at your deployment of these editors.

Then drop in a servlet container and you're done!
