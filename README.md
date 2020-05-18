<h1>Simplecloud <sup>v6</sup></h1>

<h2>Pages</h2>

<ul>
    <li><a href="/radicale/" alt="Radicale">&#x1F4C5; Radicale</a></li>
    <li><a href="smb://192.168.179.181/" alt="Samba">&#x1F4C1; Samba</a></li>
    <!-- <li><a href="/webdav/" alt="WebDAV">&#x1F4C1; WebDAV</a></li> -->
</ul>

<h2>What is SimpleCloud trying to accomplish?</h2>

<strong>Designed to be simple to install, simple to configure, simple to backup, simple to use.</strong>

<h2>Requirements</h2>

<ul>
    <li>This git repository to be cloned in <code>/data/simplecloud</code></li>
    <li>Directories <code>/data/storage</code> and <code>/data/radicale</code> exist</li>
    <li>File <code>/data/passwd</code> exist and includes one or more passwords (preferably bcrypt)</li>
    <li>Samba user + password must be created using <code>sudo smbpasswd -a &lt;user&gt;</code></li>
</ul>

<h2>References</h2>

<ul>
    <li><a href="https://radicale.org/">Radicale</a></li>
    <li><a href="http://httpd.apache.org/docs/">Apache2</a></li>
    <li><a href="https://github.com/dom111/webdav-js">webdav-js</a></li>
    <li><a href="https://wiki.samba.org/index.php/User_Documentation">Samba</a></li>
    
</ul>
