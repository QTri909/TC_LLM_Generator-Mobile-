const jsonServer = require('json-server');
const server = jsonServer.create();
const router = jsonServer.router('db.json');
const middlewares = jsonServer.defaults();

server.use(middlewares);
server.use(jsonServer.bodyParser);

// Custom route for login
server.post('/api/v1/auth/login-google', (req, res) => {
    res.json({
        accessToken: "mocked_access_token",
        refreshToken: "mocked_refresh_token"
    });
});

// Custom route for workspaces
server.get('/api/v1/workspaces/me', (req, res) => {
    const db = router.db;
    const workspaces = db.get('workspaces').value();
    res.json(workspaces);
});

// Custom POST route for create workspace
server.post('/api/v1/workspaces', (req, res) => {
    const db = router.db;
    const newWorkspace = {
        id: "mock_" + Date.now(),
        ownerId: "mock_owner",
        name: req.body.name || "Untitled Workspace",
        description: req.body.description || null,
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        projects: []
    };

    // Optional: push to db
    db.get('workspaces').push(newWorkspace).write();

    // Return 201 Created
    res.status(201).json(newWorkspace);
});

// Custom route for fetching stories by projectId
server.get('/api/v1/projects/:projectId/stories', (req, res) => {
    const db = router.db;
    const stories = db.get('stories')
        .filter({ projectId: req.params.projectId })
        .value();
    res.json(stories);
});

// Custom route for fetching a single story
server.get('/api/v1/stories/:storyId', (req, res) => {
    const db = router.db;
    const story = db.get('stories')
        .find({ id: req.params.storyId })
        .value();

    if (story) {
        res.json(story);
    } else {
        res.status(404).json({ error: "Story not found" });
    }
});

// Custom POST route for creating a new user story
server.post('/api/v1/projects/:projectId/stories', (req, res) => {
    const db = router.db;
    const newStory = {
        id: "US-" + Math.floor(1000 + Math.random() * 9000).toString(),
        projectId: req.params.projectId,
        title: req.body.title || "Untitled Story",
        role: req.body.role || "",
        action: req.body.action || "",
        reason: req.body.reason || "",
        priority: req.body.priority || "Medium",
        points: req.body.points || 3,
        acceptanceCriteria: req.body.acceptanceCriteria || [],
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString()
    };

    db.get('stories').push(newStory).write();
    res.status(201).json(newStory);
});

// Custom POST route for creating a new project within a workspace
server.post('/api/v1/workspaces/:workspaceId/projects', (req, res) => {
    const db = router.db;
    const workspaceId = req.params.workspaceId;

    // Find the workspace
    const workspace = db.get('workspaces').find({ id: workspaceId }).value();
    if (!workspace) {
        return res.status(404).json({ error: "Workspace not found" });
    }

    // Generate project key from name
    const name = req.body.name || "Untitled Project";
    const words = name.split(/\s+/);
    let keyPrefix;
    if (words.length >= 2) {
        keyPrefix = words.filter(w => w.length > 0).slice(0, 3).map(w => w[0].toUpperCase()).join('');
    } else {
        keyPrefix = name.substring(0, Math.min(4, name.length)).toUpperCase();
    }
    const projectKey = keyPrefix + '-' + Math.floor(100 + Math.random() * 900);

    const newProject = {
        id: "mock-project-" + Date.now(),
        workspaceId: workspaceId,
        createdByUserId: "mock_owner",
        projectKey: projectKey,
        name: name,
        description: req.body.description || null,
        status: "ACTIVE",
        createdAt: new Date().toISOString(),
        updatedAt: new Date().toISOString(),
        members: []
    };

    // Add business rules if provided
    const businessRules = req.body.businessRules || [];
    const savedRules = businessRules.map(rule => ({
        id: "br-" + Date.now() + '-' + Math.floor(Math.random() * 1000),
        projectId: newProject.id,
        title: rule.title || "Untitled Rule",
        description: rule.description || null,
        priority: rule.priority || 1,
        source: rule.source || null,
        createdAt: new Date().toISOString()
    }));

    // Save business rules to their own collection
    if (savedRules.length > 0) {
        savedRules.forEach(r => db.get('businessRules').push(r).write());
    }

    // Push new project into the workspace's projects array
    db.get('workspaces')
        .find({ id: workspaceId })
        .get('projects')
        .push(newProject)
        .write();

    // Return the full updated workspace
    const updatedWorkspace = db.get('workspaces').find({ id: workspaceId }).value();
    res.status(201).json(updatedWorkspace);
});

// Custom route for fetching test suites by projectId
server.get('/api/v1/projects/:projectId/test-suites', (req, res) => {
    const db = router.db;
    const suites = db.get('testSuites')
        .filter({ projectId: req.params.projectId })
        .value();
    res.json(suites);
});

// Custom POST route for creating a new test suite
server.post('/api/v1/projects/:projectId/test-suites', (req, res) => {
    const db = router.db;
    const newSuite = {
        id: "ts-" + Date.now(),
        projectId: req.params.projectId,
        name: req.body.name || "Untitled Suite",
        description: req.body.description || null,
        count: 0,
        testCaseIds: [],
        createdAt: new Date().toISOString()
    };

    db.get('testSuites').push(newSuite).write();
    res.status(201).json(newSuite);
});

// Custom route for fetching test plans by projectId
server.get('/api/v1/projects/:projectId/test-plans', (req, res) => {
    const db = router.db;
    const plans = db.get('testPlans')
        .filter({ projectId: req.params.projectId })
        .value();
    res.json(plans);
});

// Custom POST route for creating a new test plan
server.post('/api/v1/projects/:projectId/test-plans', (req, res) => {
    const db = router.db;
    const newPlan = {
        id: "tp-" + Date.now(),
        projectId: req.params.projectId,
        name: req.body.name || "Untitled Plan",
        description: req.body.description || null,
        status: "ACTIVE",
        createdAt: new Date().toISOString(),
        suites: req.body.suites || []
    };

    db.get('testPlans').push(newPlan).write();
    res.status(201).json(newPlan);
});

// Fallback logic
server.use(router);

// Start server
server.listen(3000, '0.0.0.0', () => {
    console.log('JSON Server is running on port 3000');
    console.log('Available endpoints:');
    console.log('  POST http://localhost:3000/api/v1/auth/login-google');
    console.log('  GET  http://localhost:3000/api/v1/workspaces/me');
    console.log('  POST http://localhost:3000/api/v1/workspaces');
    console.log('  POST http://localhost:3000/api/v1/workspaces/:workspaceId/projects');
    console.log('  GET  http://localhost:3000/api/v1/projects/:projectId/stories');
    console.log('  GET  http://localhost:3000/api/v1/stories/:storyId');
    console.log('  POST http://localhost:3000/api/v1/projects/:projectId/stories');
});

