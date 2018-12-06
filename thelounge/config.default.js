"use strict";

module.exports = {
	defaults: {
		name: "Freenode",
		host: "irc.freenode.net",
		port: 6697,
		password: "",
		tls: true,
		nick: "",
		username: "",
		realname: "",
		join: "#simplecloud"
	},
	prefetchMaxImageSize: 1024,
	prefetch: true,
	reverseProxy: true,
	port: 9000,
	public: false
}
